{ wrap, pkgs }:
let
  inherit (builtins) fetchurl;
  source = fetchurl {
    url = "https://www.7-zip.org/a/7z1900.exe";
    sha256 = "107gnx5rimmyr0kndxblkhrwlqn9x1aga7d07ghyxsq3bd6s16km";
  };

  bin = wrap {
    name = "7zip";
    firstRun = "wine ${source}";
    executable = "$WINEPREFIX/drive_c/Program Files/7-Zip/7zFM.exe";
  };

  desktop = pkgs.makeDesktopItem {
    name = "7zip";
    desktopName = "7-Zip";
    type = "Application";
    exec = "${bin}/bin/7zip";
    icon = fetchurl {
      url = "https://www.7-zip.org/7ziplogo.png";
      sha256 = "1nkas4wy40ffsmcji1a3gq8a61d72zp4w65jjpmqjj9wyh0j5b7q";
    };
  };
in pkgs.symlinkJoin {
  name = "7zip";
  paths = [ bin desktop ];
}
