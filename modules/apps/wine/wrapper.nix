{ pkgs }:
let inherit (builtins) length concatStringsSep;
in { arch ? ""
, wine ? if (arch == "64") then pkgs.wineWowPackages.stable else pkgs.wine
, flags ? "", executable, directory ? null, name, tricks ? [ ], setup ? ""
, firstRun ? "", home ? "$HOME/.wine" }:
## Wine Application Wrapper ##
(pkgs.writeShellApplication {
  inherit name;
  runtimeInputs = [ wine pkgs.cabextract ];
  text = ''
    # Variables
    export WINEARCH=${if (arch == "64") then "win64" else "win32"}
    export WINEPREFIX="${home}/${name}"
    export HOME="$WINEPREFIX"
    export EXECUTABLE="${executable}"

    # Setup
    ${setup}
    if [ ! -d "$WINEPREFIX" ]
    then
      mkdir -p "$WINEPREFIX"
      ${wine}/bin/wineboot
      wineserver -w

      ${
        if (length tricks) > 0 then ''
          pushd $(mktemp -d)
            wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
            chmod +x winetricks
            ./winetricks ${concatStringsSep " " tricks}
          popd
        '' else
          ""
      }

      ${firstRun}
    fi

    # Execution
    ${if (directory != null) then ''cd "${directory}"'' else ""}
    ${wine}/bin/wine${arch} ${flags} /unix "$EXECUTABLE" "$@"
    wineserver -w
  '';
})
