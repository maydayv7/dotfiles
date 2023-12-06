{
  config,
  options,
  lib,
  util,
  ...
}: let
  inherit (builtins) map;
  inherit (util.map.modules) list name;
  inherit (lib) mkOption optional types;
in {
  imports = list ./. ++ list ./desktop;

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = types.enum ((name ./desktop) ++ map (x: x + "-minimal") (name ./desktop) ++ [""]);
    default = "";
  };

  config.warnings =
    optional (config.gui.desktop == "")
    (options.gui.desktop.description + " is unset");
}
