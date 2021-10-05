{ pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec
{
  pname = "touchegg";
  version = "2.0.11";
  
  src = fetchFromGitHub
  {
    owner = "JoseExposito";
    repo = pname;
    rev = version;
    sha256 = "1zfiqs5vqlb6drnqx9nsmhgy8qc6svzr8zyjkqvwkpbgrc6ifap9";
  };

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  buildInputs =
  [
    systemd
    libinput
    pugixml
    cairo
    gtk3-x11
    pcre
  ] ++ (with xorg;
  [
    libX11
    libXtst
    libXrandr
    libXi
    libXdmcp
    libpthreadstubs
    libxcb
  ]);

  nativeBuildInputs =
  [
    pkg-config
    cmake
  ];
}
