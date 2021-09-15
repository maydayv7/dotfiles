{ config, lib, pkgs, ... }:
{
  home.file =
  {
    # Z Shell Prompt
    ".p10k.zsh".source = .././config/zsh-theme;
    
    # Neofetch Config
    ".config/neofetch/config.conf".source = .././config/neofetch;
    
    # X11 Gestures
    ".config/touchegg/touchegg.conf".source = .././config/gestures;
    
    # Custome GNOME Shell Theme
    ".themes/Adwaita/gnome-shell/gnome-shell.css".source = .././config/theme;
    
    # gEdit Color Scheme
    ".local/share/gtksourceview-4/language-specs/nix.lang".source = .././config/syntax;
    ".local/share/gtksourceview-4/styles/tango-dark.xml".source = .././config/colors;
    
    # Firefox GNOME Theme
    # https://github.com/rafaelmardojai/firefox-gnome-theme
    ".mozilla/firefox/v7/user.js".source = .././config/firefox/firefox-gnome-theme/configuration/user.js;
    ".mozilla/firefox/v7/chrome/firefox-gnome-theme".source = .././config/firefox/firefox-gnome-theme;
    ".mozilla/firefox/v7/chrome/userChrome.css".source = .././config/firefox/userChrome.css;
    
    # Custom GNOME Extensions
    ".local/share/gnome-shell/extensions/top-bar-organizer@julian.gse.jsts.xyz".source = .././config/extensions/top-bar-organizer;
    ".local/share/gnome-shell/extensions/x11gestures@joseexposito.github.io".source = .././config/extensions/x11-gestures;
  };
}
