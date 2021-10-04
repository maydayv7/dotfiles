{ config, lib, ... }:
{
  home.file =
  {
    # Font Rendering
    ".Xresources".source = ./xorg;
    
    # Wallpapers
    ".local/share/backgrounds".source = ./images;
    
    # X11 Gestures
    ".config/touchegg/touchegg.conf".source = ./gestures;
  };
}
