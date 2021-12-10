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
    type = lib.types.str;
    default = "";
  };

  config.assertions =
  [{
    assertion = desktop != "";
    message = (opt.description + " must be set");
  }];
}
