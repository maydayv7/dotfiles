{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
in
  pkgs.stdenv.mkDerivation rec {
    pname = "kitty-kitten-search";
    version = metadata.rev;

    src = pkgs.fetchFromGitHub {
      owner = "trygveaa";
      repo = pname;
      inherit (metadata) rev sha256;
    };

    dontBuild = true;
    installPhase = "mkdir -p $out/ && cp -r . $out/";

    meta = {
      description = " Kitten for searching in Kitty Terminal";
      homepage = metadata.repo;
      license = lib.licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
