{
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (lib) mkForce;
in {
  services.xserver = {
    displayManager.gdm.autoSuspend = false; # Disable Suspension
    desktopManager.gnome = {
      extraGSettingsOverrides = files.gnome.iso;
      extraGSettingsOverridePackages = [pkgs.gnome.gnome-settings-daemon];
      favoriteAppsOverride = ''
        [org.gnome.shell]
        favorite-apps=[ 'org.gnome.Epiphany.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop' ]
      '';
    };
  };

  # Essential Utilities
  environment.systemPackages = with (pkgs.gnome // pkgs); [
    epiphany
    gnome-console
    gnome-text-editor
    gnome-system-monitor
    gparted
    nautilus
  ];

  # Excluded Packages
  xdg.portal.enable = mkForce false;
  qt.enable = mkForce false;

  services.gnome = {
    core-utilities.enable = mkForce false;
    gnome-browser-connector.enable = mkForce false;
    gnome-remote-desktop.enable = mkForce false;
    gnome-user-share.enable = mkForce false;
  };

  environment.gnome.excludePackages = with pkgs.gnome; [
    gnome-backgrounds
    gnome-shell-extensions
    gnome-themes-extra
    pkgs.gnome-tour
    pkgs.gnome-user-docs
    pkgs.hicolor-icon-theme
  ];
}
