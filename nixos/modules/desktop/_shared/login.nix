{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce mkIf;
  inherit (config._shared) enable theme;
in
{
  ## Login Configuration
  config = mkIf enable {
    stylix.targets.regreet.enable = true;
    environment.persist.directories = [ "/var/lib/regreet" ];
    programs.regreet = {
      enable = true;
      package = pkgs.regreet;
      settings.commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];
        poweroff = [
          "systemctl"
          "poweroff"
        ];
      };

      extraCss = mkForce "";
      theme = mkForce theme.gtk;
      iconTheme = mkForce theme.icons;
    };
  };
}
