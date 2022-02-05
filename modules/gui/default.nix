{ config, options, lib, ... }:
let inherit (lib) mkOption optional types;
in {
  imports = [ ./fonts.nix ./gnome.nix ./xorg.nix ];

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = types.nullOr (types.enum [ "gnome" "gnome-minimal" ]);
    default = null;
  };

  config.warnings = optional (config.gui.desktop == null)
    [ (options.gui.desktop.description + " is unset") ];
}
