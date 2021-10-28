{ lib, pkgs, ... }:
{
  ## Discord Configuration ##
  home.packages = with pkgs;
  [
    betterdiscordctl
    discord
  ];

  # Plugins
  home.file =
  {
    ".config/BetterDiscord/plugins" =
    {
      source = ./plugins;
      recursive = true;
    };
  };
}
