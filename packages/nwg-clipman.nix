{
  lib,
  pkgs,
  ...
}:
with pkgs;
  python310Packages.buildPythonApplication rec {
    pname = "nwg-clipman";
    version = "0.2.1";

    src = fetchFromGitHub {
      owner = "nwg-piotr";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-nOLd1GmaXflBAZlx4SVxr6PLbXJrQnNN6yUTpeNUd/E=";
    };

    buildInputs = [gtk3];
    nativeBuildInputs = [
      gobject-introspection
      wrapGAppsHook
    ];

    propagatedBuildInputs = [
      atk
      gdk-pixbuf
      gtk-layer-shell
      pango
      python310Packages.pygobject3
      cliphist
      wl-clipboard
      xdg-utils
    ];

    dontWrapGApps = true;
    doCheck = false;
    preFixup = ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}");
    '';

    meta = with lib; {
      mainProgram = pname;
      homepage = "https://github.com/nwg-piotr/nwg-clipman";
      description = "GTK3-based GUI for cliphist";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }
