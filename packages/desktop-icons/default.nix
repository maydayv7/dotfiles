{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation rec {
    pname = "desktop-icons";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "Geronymos";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    buildInputs = [gtk3 gtk-layer-shell pkg-config];
    NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";
    installPhase = ''
      mkdir -p $out/bin
      cp -r dicons $out/bin/dicons
    '';

    meta = with lib; {
      mainProgram = "dicons";
      description = "Show Files from a Directory on Wayland Desktop";
      homepage = metadata.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
