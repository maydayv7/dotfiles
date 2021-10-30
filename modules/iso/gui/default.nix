[
  ({ lib, ... }:
  rec
  {
    options.gui.desktop = lib.mkOption
    {
      description = "GUI Desktop Configuration";
      type = lib.types.str;
      default = "gnome";
    };
  })

  ./gnome
  ./xorg
]
