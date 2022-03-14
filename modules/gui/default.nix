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
      nullOr (enum ((module' ./.) ++ map (x: x + "-minimal") (module' ./.)));
    default = null;
  };

  config.warnings =
    optional (config.gui.desktop == null)
    (options.gui.desktop.description + " is unset");
}
