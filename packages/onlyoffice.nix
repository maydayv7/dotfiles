{ pkgs, ... }:
with pkgs;
let
  noto-fonts-cjk = fetchurl
  {
    url = "https://github.com/googlefonts/noto-cjk/raw/v20201206-cjk/NotoSansCJKsc-Regular.otf";
    sha256 = "sha256-aJXSVNJ+p6wMAislXUn4JQilLhimNSedbc9nAuPVxo4=";
  };
  
  runtimeLibs = lib.makeLibraryPath
  [
    curl
    glibc
    libudev0-shim
    pulseaudio
  ];
in
stdenv.mkDerivation rec
{
  pname = "onlyoffice-desktopeditors";
  version = "6.4.1";
  minor = null;
  
  src = fetchurl
  {
    url = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_amd64.deb";
    sha256 = "sha256-WCjCljA7yB7Zm/I4rDZnfgaUQpDUKwbUvL7hkIG8cVM=";
  };
  
  nativeBuildInputs =
  [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook
  ];
  
  buildInputs =
  [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    dbus
    dconf
    fontconfig
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk2
    gtk3
    libpulseaudio
    libdrm
    nspr
    nss
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
  ];
  
  dontWrapQtApps = true;
  
  unpackPhase =
  ''
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
  '';
  
  preConfigure =
  ''
    cp --no-preserve=mode,ownership ${noto-fonts-cjk} opt/onlyoffice/desktopeditors/fonts/
  '';
  
  installPhase =
  ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share}
    mv usr/bin/* $out/bin
    mv usr/share/* $out/share/
    mv opt/onlyoffice/desktopeditors $out/share
    substituteInPlace $out/bin/onlyoffice-desktopeditors \
      --replace "/opt/onlyoffice/" "$out/share/"
    ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors
    substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
      --replace "/usr/bin/onlyoffice-desktopeditor" "$out/bin/DesktopEditor"
    runHook postInstall
  '';
  
  preFixup =
  ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
      --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale" \
      --set QT_QPA_PLATFORM "xcb"
      # the bundled version of qt does not support wayland
    )
  '';
}
