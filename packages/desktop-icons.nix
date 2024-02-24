{
  lib,
  pkgs,
  ...
}:
with pkgs;
  stdenv.mkDerivation rec {
    pname = "desktop-icons";
    version = "2023-10-16";

    src = fetchFromGitHub {
      owner = "Geronymos";
      repo = pname;
      rev = "71998254e3e304b8cdc2b168a54bb7c79376fbcc";
      sha256 = "sha256-22L1WFSQRVq7c7IZbdZ4hYVpxccSnxKfpLMLASwXD+Y=";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/maydayv7/desktop-icons/commit/a70833a88d52aeb3a6c4d044b124b012fd607b9b.patch";
        sha256 = "sha256-8RlUKyXNt1xfiiBsYKuZYljYSzzsNJSQXBPfmi+DGcY=";
      })
    ];

    buildInputs = [gtk3 pkg-config];
    propagatedBuildInputs = [glib gtk-layer-shell];
    NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

    installPhase = ''
      mkdir -p $out/bin
      cp -r dicons $out/bin/dicons
    '';

    meta = with lib; {
      mainProgram = "dicons";
      description = "Show Files from a Directory on Wayland Desktop";
      homepage = "https://github.com/Geronymos/desktop-icons";
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
