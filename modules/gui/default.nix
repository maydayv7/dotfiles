{ lib, ... }:
rec
{
  imports =
  [
    ./fonts.nix
    ./gnome.nix
    ./xorg.nix
  ];

  options.gui.desktop = lib.mkOption
  {
    description = "GUI Desktop Configuration";
    type = lib.types.str;
  };
}
