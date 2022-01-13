{ config, options, lib, ... }:
let
  inherit (lib) mkOption types;
  desktop = config.gui.desktop;
  opt = options.gui.desktop;
in rec {
  imports = [ ./fonts.nix ./gnome.nix ./xorg.nix ];

  options.gui.desktop = mkOption {
    description = "GUI Desktop Choice";
    type = types.nullOr (types.enum [ "gnome" "gnome-minimal" ]);
    default = null;
  };

  config.warnings =
    if (desktop == null) then [ (opt.description + " is unset") ] else [ ];
}
