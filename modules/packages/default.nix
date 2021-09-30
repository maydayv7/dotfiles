{ lib, pkgs, ... }:
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
    onlyoffice-bin
    
    # Internet
    google-chrome
    megasync
    teams
    zoom-us
    
    # Utilities
    dconf2nix
    lolcat
    neofetch
    touchegg
  ];
}
