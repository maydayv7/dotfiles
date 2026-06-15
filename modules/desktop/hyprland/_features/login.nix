_: {
  nixos = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkForce;
  in {
    stylix.targets.regreet.enable = true;
    environment.persist.directories = ["/var/lib/regreet"];
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
      theme = mkForce config.gui.gtk.theme;
      iconTheme = with config.stylix.icons;
        mkForce {
          name = dark;
          inherit package;
        };
    };
  };
}
