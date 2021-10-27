{ lib, pkgs, ... }:
{
  ## Discord Configuration ##
  home.packages = with pkgs;
  [
    betterdiscordctl
    discord
  ];
  
  home.file =
  {
    # Plugins
    ".config/BetterDiscord/plugins" =
    {
      source = ./plugins;
      recursive = true;
    };
  };
}
