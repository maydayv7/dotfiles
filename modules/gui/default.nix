{
  config,
  options,
  lib,
  util,
  ...
}: let
  inherit (builtins) map;
  inherit (util.map.modules) list name;
  inherit (lib) mkIf mkOption optional types;
  enable = config.gui.desktop != "";
in {
  imports = list ./. ++ list ./desktop;

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = types.enum ((name ./desktop) ++ map (x: x + "-minimal") (name ./desktop) ++ [""]);
    default = "";
  };

  config =
    {
      # Warning
      warnings = optional (!enable) (options.gui.desktop.description + " is unset");
    }
    // (mkIf enable {
      # Autostart Apps
      user.persist.directories = [".config/autostart"];

      # Desktop Integration
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    });
}
