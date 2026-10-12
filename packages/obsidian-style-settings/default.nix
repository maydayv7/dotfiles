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
    pname = "obsidian-style-settings";
    owner = "mgmeyers";
    repo = "obsidian-style-settings";
    inherit (metadata) version hashes;

    meta = {
      description = "Configure CSS theme, snippet, and plugin settings in Obsidian";
      homepage = metadata.repo;
      license = lib.licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
