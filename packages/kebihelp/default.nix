{
  lib,
  pkgs,
  ...
}:
with pkgs;
with python311Packages; let
  metadata = import ./metadata.nix;
in
  buildPythonPackage rec {
    pname = "kebihelp";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "juienpro";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    build-system = [setuptools-scm];
    nativeBuildInputs = [libsForQt5.qt5.wrapQtAppsHook];
    propagatedBuildInputs = [prettytable pyqt5 pyqt5-sip libsForQt5.qt5.qtwayland];

    format = "pyproject";
    dontWrapQtApps = true;
    dontCheckRuntimeDeps = true;
    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    meta = with lib; {
      description = "Universal Keybinding helper written in Python and QT5";
      homepage = metadata.repo;
      license = licenses.mit;
      maintainers = ["maydayv7"];
    };
  }
