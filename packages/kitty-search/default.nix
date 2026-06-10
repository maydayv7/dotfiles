{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  metadata = import ./metadata.nix;
in
  stdenv.mkDerivation rec {
    pname = "kitty-kitten-search";
    version = metadata.rev;

    src = fetchFromGitHub {
      owner = "trygveaa";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = "mkdir -p $out/ && cp -r . $out/";

    meta = with lib; {
      description = " Kitten for searching in Kitty Terminal";
      homepage = metadata.repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
