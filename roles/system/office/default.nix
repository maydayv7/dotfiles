{ lib, pkgs, ... }:
{
  ## Office Environment Configuration ##
  # Applications
  environment.systemPackages = with pkgs;
  [
    # Productivity
    bluej
    gscan2pdf
    libreoffice
    unstable.onlyoffice-bin

    # Internet
    google-chrome
    megasync
    teams
    whatsapp-for-linux
    zoom-us

    # Entertainment
    celluloid
    handbrake
    lollypop
  ];
}
