{ config, lib, ... }:
{
  home.file =
  {
    # Z Shell Prompt
    ".p10k.zsh".source = ../config/zsh-theme;
    
    # Wallpapers
    ".local/share/backgrounds".source = ../config/images;
    
    # Neofetch Config
    ".config/neofetch/config.conf".source = ../config/neofetch;
    
    # X11 Gestures
    ".config/touchegg/touchegg.conf".source = ../config/gestures;
    
    # Custome GNOME Shell Theme
    ".themes/Adwaita/gnome-shell/gnome-shell.css".source = ../config/theme;
    
    # gEdit Color Scheme
    ".local/share/gtksourceview-4/styles/tango-dark.xml".source = ../config/colors;
    ".local/share/gtksourceview-4/language-specs/nix.lang".source = ../config/syntax;
  };
}
