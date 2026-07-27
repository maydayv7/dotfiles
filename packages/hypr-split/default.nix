{pkgs, ...}: let
  metadata = import ./metadata.nix;

  src = pkgs.fetchFromGitHub {
    owner = "maydayv7";
    repo = "hyprsplit";
    inherit (metadata) rev sha256;
  };
in
  pkgs.runCommand "hyprsplit" {} ''
    mkdir -p $out
    cp ${src}/init.lua $out/init.lua
  ''
