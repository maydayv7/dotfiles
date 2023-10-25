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

  config.assertions = [
    {
      assertion = config.gui.desktop != "";
      message = options.gui.desktop.description + " must be set";
    }
  ];
}
