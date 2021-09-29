{ config, lib, pkgs, ... }:
{
  # Discord Configuration
  home.packages = with pkgs;
  [
    betterdiscordctl
    discord
  ];
  
  # Plugins and Theme
  home.file =
  {
    ".config/BetterDiscord/themes/DNOME.theme.css".source = ./theme;
    ".config/BetterDiscord/plugins" =
    {
      source = ./plugins;
      recursive = true;
    };
  };
}
