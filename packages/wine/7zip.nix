{
  lib,
  build,
  pkgs,
  wine,
  ...
}: let
  inherit (pkgs) copyDesktopItems fetchurl makeDesktopItem;
  inherit (build) copyDesktopIcons makeDesktopIcon mkWindowsApp;
in
  mkWindowsApp rec {
    inherit wine;
    pname = "7zip";
    version = "2601";
    src = fetchurl {
      url = "https://www.7-zip.org/a/7z${version}.exe";
      sha256 = "sha256-YVl2WY+ADHCCfFpH5owrDSsX0Ei5chugccivgl0kdr0=";
    };

    dontUnpack = true;
    wineArch = "win32";
    fileMap = {};
    enableInstallNotification = false;
    nativeBuildInputs = [
      copyDesktopItems
      copyDesktopIcons
    ];

    winAppInstall = ''
      $WINE start /unix ${src} /S
      wineserver -w
    '';

    winAppRun = ''
      $WINE start /unix "$WINEPREFIX/drive_c/Program Files/7-Zip/7zFM.exe" "$ARGS"
    '';

    installPhase = ''
      runHook preInstall
      ln -s $out/bin/.launcher $out/bin/${pname}
      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = "7-Zip";
        genericName = "Archive Manager";
        categories = [
          "Office"
          "Utility"
        ];
        mimeTypes = builtins.map (n: "application/" + n) [
          "epub+zip"
          "x-zip-compressed-fb2"
          "x-cbt"
          "x-cb7"
          "x-7z-compressed"
          "vnd.rar"
          "x-tar"
          "zip"
        ];
      })
    ];

    desktopIcon = makeDesktopIcon {
      name = "7zip";
      src = fetchurl {
        url = "https://www.7-zip.org/7ziplogo.png";
        sha256 = "1nkas4wy40ffsmcji1a3gq8a61d72zp4w65jjpmqjj9wyh0j5b7q";
      };
    };

    meta = with lib; {
      description = "File Archiver with a High Compression Ratio";
      homepage = "https://www.7-zip.org/";
      license = licenses.bsd3;
      platforms = platforms.linux;
      maintainers = ["maydayv7"];
    };
  }
