{ config, lib, pkgs, ... }:
{
  services.xserver =
  {   
    # Touchpad
    libinput.enable = true;
    libinput.touchpad.tapping = true;
    libinput.touchpad.tappingDragLock = true;
    
    # GNOME
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  
  # GNOME Desktop Integration
  programs.dconf.enable = true;
  services =
  {
    dbus.packages = [ pkgs.gnome.dconf ];
    udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
    gnome =
    {
      chrome-gnome-shell.enable = true;
      gnome-keyring.enable = true;
      gnome-remote-desktop.enable = true;
    };
  };
  
  # Excluded GNOME Packages
  environment.gnome.excludePackages = with pkgs;
  [
    gnome.totem
    gnome.gnome-music
  ];
  
  environment.systemPackages = with pkgs;
  [
    # GNOME Apps
    gnome.dconf-editor
    gnome.gnome-boxes
    gnome.gnome-dictionary
    gnome.gnome-notes
    gnome.gnome-sound-recorder
    gnome.gnome-terminal
    gnome.gnome-todo
    gnome.gnome-tweaks
    gnome.polari
    
    # GNOME Games
    gnome.gnome-chess
    gnome.gnome-mines
    gnome.gnome-sudoku
    gnome.quadrapassel
    
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
    touchegg
    
    # GNOME Shell Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.custom-hot-corners-extended
    dash-to-panel
    gnomeExtensions.just-perfection
    gnomeExtensions.lock-keys
    gnomeExtensions.screenshot-locations
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.vitals
    gnomeExtensions.x11-gestures
  ];
  
  # Touchegg X11 Gestures Daemon
  systemd.services.touchegg =
  {
    enable = true;
    description = "The daemon for Touchégg X11 Gestures.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = 
    {
      Type = "simple";
      Group = "input";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.touchegg}/bin/touchegg --daemon";
    };
  };
}
