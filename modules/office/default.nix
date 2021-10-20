{ lib, pkgs, ... }:
{
  ## Office Environment Configuration ##
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
  ];
}
