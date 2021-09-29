{ config, lib, ... }:
{
  home.file =
  {
    # Wallpapers
    ".local/share/backgrounds" =
    {
      source = ./images;
      recursive = true;
    };
    
    # X11 Gestures
    ".config/touchegg/touchegg.conf".source = ./gestures;
  };
}
