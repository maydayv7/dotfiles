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
    ".local/share/fonts" =
    {
      source = ./fonts;
      recursive = true;
    };
  };
  
  # Xorg Configuration
  xresources.extraConfig = (builtins.readFile ./xorg);
}
