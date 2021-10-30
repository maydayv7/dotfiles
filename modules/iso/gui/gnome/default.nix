{ config, lib, pkgs, ... }:
let
  cfg = config.gui.desktop;
in rec
{
  ## GNOME Desktop Configuration ##
  config = lib.mkIf (cfg == "gnome")
  {
    gui.xorg.enable = true;
    services.xserver =
    {   
      # Touchpad
      libinput.enable = true;
      libinput.touchpad.tapping = true;

      # GNOME
      desktopManager.gnome.enable = true;
      displayManager.gdm =
      {
        enable = true;
        autoSuspend = false;
      };
    };

    # Excluded GNOME Packages
    environment.gnome.excludePackages = with pkgs;
    [
      gnome.baobab
      gnome.geary
      gnome.gnome-backgrounds
      gnome.gnome-calendar
      gnome.gnome-characters
      gnome-connections
      gnome.gnome-contacts
      gnome.gnome-logs
      gnome.gnome-maps
      gnome.gnome-music
      gnome.gnome-weather
      gnome-photos
      gnome.simple-scan
      gnome.simple-scan
      gnome.totem
      gnome-tour
      gnome-user-docs
      gnome.yelp
      hicolor-icon-theme
    ];
  };
}
