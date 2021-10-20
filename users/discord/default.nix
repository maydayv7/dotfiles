{ config, lib, pkgs, ... }:
{
  ## Discord Configuration ##
  home.packages = with pkgs;
  [
    betterdiscordctl
    discord
  ];
  
  home.file =
  {
    # Theme
    ".config/BetterDiscord/themes/DNOME.theme.css".source = ./theme;
    
    # Plugins
    ".config/BetterDiscord/plugins" =
    {
      source = ./plugins;
      recursive = true;
    };
  };
}
