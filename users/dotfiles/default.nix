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
  
  # XDG FHS Configuration
  xdg =
  {
    enable = true;
    
    # User Directories
    userDirs =
    {
      enable = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
    };
  };
  
  # Xorg Configuration
  xresources.extraConfig = (builtins.readFile ./xorg);
}
