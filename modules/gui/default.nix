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
  imports = module ./.;

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = with types;
      nullOr (enum ((module' ./desktop) ++ map (x: x + "-minimal") (module' ./desktop)));
    default = null;
  };

  config.assertions = [
    {
      assertion = config.gui.desktop != null;
      message = options.gui.desktop.description + " must be set";
    }
  ];
}
