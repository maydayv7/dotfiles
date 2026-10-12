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
  obsidian.mkPlugin {
    pname = "obsidian-outliner";
    owner = "vslinko";
    repo = "obsidian-outliner";
    inherit (metadata) version hashes;

    meta = {
      description = "Work with your lists like in Workflowy or RoamResearch, in Obsidian";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }
