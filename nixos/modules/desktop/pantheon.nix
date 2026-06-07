# Pantheon desktop environment
{ config, inputs, ... }:
{
  flake.modules = {
    nixos.pantheon = nixosArgs: let
      inherit (nixosArgs) config lib pkgs;
      inherit (lib) mkIf;
    in {
      config = mkIf (config.gui.desktop or "" == "pantheon") {
        gui.fonts.enable = true;
        services.xserver = {
          enable = true;
          desktopManager.pantheon.enable = true;
          displayManager.lightdm.enable = true;
        };
        services.displayManager.defaultSession = "pantheon";

        environment.sessionVariables = {
          "NIXOS_OZONE_WL" = "1";
        };
      };
    };

    homeManager.pantheon = hmArgs: let
      inherit (hmArgs) config lib;
    in {
      home.persist.directories = [
        ".config/autostart"
      ];
    };
  };
}
