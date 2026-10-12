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
    pname = "obsidian-adwaita";
    owner = "birneee";
    repo = "obsidian-adwaita-theme";
    inherit (metadata) rev sha256;

    meta = {
      description = "GNOME Adwaita theme for Obsidian";
      homepage = metadata.repo;
      license = lib.licenses.mit;
      maintainers = ["maydayv7"];
    };
  }
