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
    pname = "obsidian-calendar";
    owner = "liamcain";
    repo = "obsidian-calendar-plugin";
    inherit (metadata) version hashes;

    meta = {
      description = "Calendar view of your daily notes for Obsidian";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }
