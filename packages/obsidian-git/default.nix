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
    pname = "obsidian-git";
    owner = "Vinzent03";
    repo = "obsidian-git";
    inherit (metadata) version hashes;

    meta = {
      description = "Backup and version your Obsidian vault with git";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }
