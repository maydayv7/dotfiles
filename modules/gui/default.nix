{ config, options, lib, ... }:
with { inherit (lib) mkOption optional types util; }; {
  imports = util.map.module ./.;

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = types.nullOr (types.enum [ "gnome" "gnome-minimal" ]);
    default = null;
  };

  config.warnings = optional (config.gui.desktop == null)
    (options.gui.desktop.description + " is unset");
}
