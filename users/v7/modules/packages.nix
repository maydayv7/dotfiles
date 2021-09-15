{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs;
  [
    bluej
    calibre
    dconf2nix
    discord
    gscan2pdf
    megasync
    teams
    zoom-us
    
    # GNOME Circle
    apostrophe
    drawing
    deja-dup
    giara
    gimp
    gnome-podcasts
    gnome-passwordsafe
    fractal
    kooha
    shortwave 
    
    # Unstable Packages
    #fragments
    #markets
    #wike
  ];
}
