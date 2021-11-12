{ lib, ... }:
rec
{
  imports =
  [
    ./fonts
    ./gnome
    ./xorg
  ];

  options.gui.desktop = lib.mkOption
  {
    description = "GUI Desktop Configuration";
    type = lib.types.str;
  };
}
