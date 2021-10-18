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
    unstable.onlyoffice-bin
    
    # Internet
    google-chrome
    megasync
    teams
    whatsapp-for-linux
    zoom-us
    
    # Utilities
    dconf2nix
    lolcat
    neofetch
    
    # System Scripts
    scripts.management
  ];
}
