{ lib, inputs, pkgs, ... }:
{
  # Apps and Games
  environment.systemPackages = with pkgs;
  [
    # Productivity
    bluej
    celluloid
    gscan2pdf
    libreoffice
    lollypop
    custom.onlyoffice
    
    # Internet
    google-chrome
    megasync
    teams
    zoom-us
    
    # Utilities
    dconf2nix
    lolcat
    neofetch
    
    # System Scripts
    scripts.management
  ];
}
