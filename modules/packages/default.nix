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
    
    # Internet
    google-chrome
    megasync
    teams
    zoom-us
    
    # Utilities
    dconf2nix
    lolcat
    neofetch
    
    # Unstable Packages
    unstable.onlyoffice-bin
    
    # System Scripts
    scripts.management
  ];
}
