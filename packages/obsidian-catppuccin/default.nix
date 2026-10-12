{
  lib,
  pkgs,
  ...
}: let
  metadata = import ./meta.nix;
  obsidian = import ../_obsidian.nix {
    inherit lib;
    inherit (pkgs) stdenvNoCC fetchFromGitHub fetchurl;
  };
in
  obsidian.mkTheme {
    pname = "obsidian-catppuccin";
    owner = "catppuccin";
    repo = "obsidian";
    inherit (metadata) rev sha256;

    meta = {
      description = "Soothing pastel theme for Obsidian";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }
