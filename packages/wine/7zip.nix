{ system ? builtins.currentSystem, lib, pkgs, wine, ... }:
let
  inherit (pkgs) copyDesktopItems fetchurl makeDesktopItem;
  inherit (lib.wine."${system}") copyDesktopIcons makeDesktopIcon mkWindowsApp;
in mkWindowsApp rec {
  inherit wine;
  pname = "7zip";
  version = "1900";
  src = fetchurl {
    url = "https://www.7-zip.org/a/7z1900.exe";
    sha256 = "107gnx5rimmyr0kndxblkhrwlqn9x1aga7d07ghyxsq3bd6s16km";
  };

  dontUnpack = true;
  wineArch = "win32";
  enableInstallNotification = false;
  fileMap = { };
  nativeBuildInputs = [ copyDesktopItems copyDesktopIcons ];

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
    mimeType = builtins.concatStringsSep ";" [
      "application/epub+zip"
      "application/x-zip-compressed-fb2"
      "application/x-cbt"
      "application/x-cb7"
      "application/x-7z-compressed"
      "application/vnd.rar"
      "application/x-tar"
      "application/zip"
    ];
  in [
    (makeDesktopItem {
      inherit mimeType;
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "7-Zip";
      genericName = "Archive Manager";
      categories = "Office;";
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
    maintainers = [ "maydayv7" ];
  };
}
