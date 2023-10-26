{
  config,
  options,
  lib,
  ...
}: let
  inherit (builtins) map;
  inherit (util.map) module module';
  inherit (lib) mkOption optional types util;
in {
  imports = module ./. ++ module ./desktop;

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = types.enum ((module' ./desktop) ++ map (x: x + "-minimal") (module' ./desktop) ++ [""]);
    default = "";
  };

  config.warnings =
    optional (config.gui.desktop == "")
    (options.gui.desktop.description + " is unset");
}
