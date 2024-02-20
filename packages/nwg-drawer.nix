{
  lib,
  pkgs,
  ...
}:
with pkgs;
  unstable.buildGo122Module rec {
    pname = "nwg-drawer";
    version = "0.4.7";

    src = fetchFromGitHub {
      owner = "nwg-piotr";
      repo = "nwg-drawer";
      rev = "v${version}";
      sha256 = "sha256-rBb2ArjllCBO2+9hx3f/c+uUQD1nCZzzfQGz1Wovy/0=";
    };

    vendorHash = "sha256-L8gdJd5cPfQrcSXLxFx6BAVWOXC8HRuk5fFQ7MsKpIc=";

    nativeBuildInputs = [
      gobject-introspection
      pkg-config
      wrapGAppsHook
    ];

    buildInputs = [
      cairo
      gtk-layer-shell
      gtk3
    ];

    doCheck = false; # Too slow
    preInstall = ''
      mkdir -p $out/share/nwg-drawer
      cp -r desktop-directories drawer.css $out/share/nwg-drawer
    '';

    preFixup = ''
      # Make xdg-open overrideable at runtime
      gappsWrapperArgs+=(
        --suffix PATH : ${xdg-utils}/bin
        --prefix XDG_DATA_DIRS : $out/share
      )
    '';

    meta = with lib; {
      mainProgram = "nwg-drawer";
      description = "Application Drawer for Wayland compositors";
      homepage = "https://github.com/nwg-piotr/nwg-drawer";
      license = licenses.mit;
      maintainers = ["maydayv7"];
      platforms = platforms.linux;
    };
  }
