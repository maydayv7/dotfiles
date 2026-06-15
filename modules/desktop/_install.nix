## Install Media Desktop Configuration ##
_: {
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [(import ./gnome/_common.nix {})];

  services = {
    displayManager.gdm = {
      banner = "Install Media";
      autoSuspend = false;
    };

    desktopManager.gnome = {
      extraGSettingsOverridePackages = [pkgs.gnome-settings-daemon];
      favoriteAppsOverride = ''
        [org.gnome.shell]
        favorite-apps=[ 'org.gnome.Epiphany.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop' ]
      '';

      extraGSettingsOverrides = ''
        [org.gnome.shell]
        welcome-dialog-last-shown-version='9999999999'

        [org.gnome.desktop.session]
        idle-delay=0

        [org.gnome.settings-daemon.plugins.power]
        sleep-inactive-ac-type='nothing'
        sleep-inactive-battery-type='nothing'
      '';
    };
  };

  # Essential Utilities
  environment.systemPackages = with pkgs; [
    gparted
    epiphany
    gnome-console
    gnome-system-monitor
    gnome-text-editor
    nautilus
  ];

  # Excluded Packages
  services.gnome = {
    core-apps.enable = mkForce false;
    gnome-browser-connector.enable = mkForce false;
    gnome-remote-desktop.enable = mkForce false;
    gnome-user-share.enable = mkForce false;
    rygel.enable = mkForce false;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-backgrounds
    gnome-tour
    gnome-user-docs
    orca
  ];

  # Disable suspension
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions") {
          return polkit.Result.NO;
        }
    });
  '';
}
