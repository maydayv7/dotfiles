{config, ...}: let
  inherit (config) util;
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.homeManager = {
    default.imports =
      util.map.array [
        "base"
        "filesystem"
        "user"
        "nix"
        "shell"
        "theme"
      ]
      homeManager;

    cli.imports =
      util.map.array [
        "base"
        "filesystem"
        "user-cli"
        "nix"
        "shell"
        "theme-cli"
      ]
      homeManager;
  };
}
