{
  config,
  options,
  lib,
  util,
  ...
}: let
  inherit (builtins) map;
  inherit (util.map.modules) list name;
  inherit (lib) hasSuffix mkEnableOption mkIf mkOption optional types;
  inherit (config.gui) desktop;
in {
  imports = list ./. ++ list ./desktop;

  options.gui = {
    fancy = mkEnableOption "Enable Fancy GUI Effects";
    display = mkOption {
      description = "Main GUI Display";
      type = types.str;
      default = "";
      example = "HDMI-A-1";
    };
    desktop = mkOption {
      description = "GUI Desktop Choice";
      type = types.enum ((name ./desktop) ++ map (x: x + "-iso") (import ./desktop/iso.nix) ++ [""]);
      default = "";
    };
  };

  config =
    {
      # Warning
      warnings = optional (desktop == "") (options.gui.desktop.description + " is unset");
    }
    // (mkIf (desktop != "" && !(hasSuffix "-iso" desktop))
      {
        # Autostart Apps
        user.persist.directories = [".config/autostart"];

        # Utilities
        programs.seahorse.enable = true;
        services = {
          gvfs.enable = true;
          gnome.gnome-keyring.enable = true;
        };

        # Desktop Integration
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
        };
      });
}
