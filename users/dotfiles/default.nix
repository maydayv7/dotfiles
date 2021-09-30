{ config, lib, ... }:
{
  home.file =
  {
    # Wallpapers
    ".local/share/backgrounds".source = ./images;
    
    # X11 Gestures
    ".config/touchegg/touchegg.conf".source = ./gestures;
  };
}
