{ lib, ... }:
{
  ## User Dotfiles ##
  home.file =
  {
    # Wallpapers
    ".local/share/backgrounds".source = ./images;
    
    # X11 Gestures
    ".config/touchegg/touchegg.conf".source = ./gestures;
    
    # Document Templates
    "Templates" =
    {
      source = ./templates;
      recursive = true;
    };
    
    # Font Rendering
    ".Xresources".source = ./xorg;
    ".local/share/fonts" =
    {
      source = ./fonts;
      recursive = true;
    };
  };
}
