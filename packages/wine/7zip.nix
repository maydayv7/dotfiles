{
  lib,
  build,
  pkgs,
  wine,
  ...
}: let
  inherit (builtins) concatLists map;
  inherit (pkgs) copyDesktopItems fetchurl makeDesktopItem;
  inherit (build) copyDesktopIcons makeDesktopIcon mkWindowsApp;
in
  mkWindowsApp rec {
    inherit wine;
    pname = "7zip";
    version = "2404";
    src = fetchurl {
      url = "https://www.7-zip.org/a/7z${version}.exe";
      sha256 = "sha256-0Mj79dcm5B2F5RVZI0tbOUVSLoQgjfUjntJfAu9j7/M=";
    };

    dontUnpack = true;
    wineArch = "win32";
    enableInstallNotification = false;
    fileMap = {};
    nativeBuildInputs = [copyDesktopItems copyDesktopIcons];

    winAppInstall = ''
      wine start /unix ${src} /S
      wineserver -w
    '';

    winAppRun = ''
      wine start /unix "$WINEPREFIX/drive_c/Program Files/7-Zip/7zFM.exe" "$ARGS"
    '';

    installPhase = ''
      runHook preInstall
      ln -s $out/bin/.launcher $out/bin/${pname}
      runHook postInstall
    '';

    desktopItems = let
      textTypes = map (n: "text/" + n) [];
      appTypes = map (n: "application/" + n) ["epub+zip" "x-zip-compressed-fb2" "x-cbt" "x-cb7" "x-7z-compressed" "vnd.rar" "x-tar" "zip"];
      mimeTypes = concatLists [textTypes appTypes];
    in [
      (makeDesktopItem {
        inherit mimeTypes;
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = "7-Zip";
        genericName = "Archive Manager";
        categories = ["Office" "Utility"];
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
