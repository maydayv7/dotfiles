{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  environment = {
    # Utilities
    systemPackages = with pkgs; [epiphany gparted];

    # Excluded Packages
    xfce.excludePackages = with pkgs; [
      tango-icon-theme
      xfce4-icon-theme
      xfwm4-themes
    ];
  };

  # Disabled Services
  services.tumbler.enable = mkForce false;
  services.accounts-daemon.enable = mkForce false;
}
