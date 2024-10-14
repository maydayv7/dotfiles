{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  # Excluded Packages
  environment.xfce.excludePackages = with (pkgs.xfce // pkgs); [
    tango-icon-theme
    xfce4-icon-theme
    xfwm4-themes
  ];

  # Disabled Services
  services.tumbler.enable = mkForce false;
  services.accounts-daemon.enable = mkForce false;
}
