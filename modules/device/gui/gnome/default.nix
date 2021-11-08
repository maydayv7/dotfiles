{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.gui.desktop;
in rec
{
  imports = [ "${inputs.unstable}/nixos/modules/services/x11/touchegg.nix" ];

  ## GNOME Desktop Configuration ##
  config = lib.mkIf (cfg == "gnome")
  {
    gui.xorg.enable = true;
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

    # Desktop Integration
    programs.dconf.enable = true;
    programs.gnupg.agent.pinentryFlavor = "gnome3";
    services =
    {
      dbus.packages = [ pkgs.gnome.dconf ];
      udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
      touchegg =
      {
        enable = true;
        package = pkgs.unstable.touchegg;
      };
      gnome =
      {
        chrome-gnome-shell.enable = true;
        experimental-features.realtime-scheduling = true;
        gnome-initial-setup.enable = true;
        gnome-keyring.enable = true;
        gnome-remote-desktop.enable = true;
        sushi.enable = true;
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
      fractal
      unstable.fragments
      giara
      gimp
      gnome-podcasts
      gnome-passwordsafe
      kooha
      unstable.markets
      shortwave
      unstable.wike

      # GNOME Shell Extensions
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.compiz-windows-effect
      gnomeExtensions.compiz-alike-magic-lamp-effect
      gnomeExtensions.custom-hot-corners-extended
      gnomeExtensions.dash-to-panel
      # gnomeExtensions.fly-pie
      gnomeExtensions.just-perfection
      gnomeExtensions.lock-keys
      gnomeExtensions.screenshot-locations
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.vitals
      gnomeExtensions.x11-gestures

      # Utilities
      dconf2nix
      gnuchess
    ];
  };
}
