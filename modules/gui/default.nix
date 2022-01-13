{ config, options, lib, ... }:
let
  desktop = config.gui.desktop;
  opt = options.gui.desktop;
in rec
{
  imports =
  [
    ./fonts.nix
    ./gnome.nix
    ./xorg.nix
  ];

  options.gui.desktop = lib.mkOption
  {
    description = "GUI Desktop Choice";
    type = lib.types.enum [ null "gnome" "gnome-minimal" ];
    default = null;
  };

  config.warnings = if (desktop == null) then [ (opt.description + " is unset") ] else [ ];
}
