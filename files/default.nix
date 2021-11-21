{ ... }:
let
  inherit (builtins) readFile;
in
{
  ## Dotfiles ##
  # Dconf Settings
  dconf = ./dconf;

  # Discord Chat
  discord =
  {
    plugins = ./discord/plugins;
    theme = readFile ./discord/theme.css;
  };

  # Custom Fonts
  fonts =
  {
    path = ./fonts;
    config = readFile ./fonts/fontconfig;
  };

  # gEdit Text Editor
  gedit =
  {
    syntax = readFile ./gedit/nix.lang;
    theme = readFile ./gedit/tango-dark.xml;
  };

  # GNOME Desktop
  gnome =
  {
    bookmarks = readFile ./gnome/bookmarks;
    theme = readFile ./gnome/gnome-shell.css;
  };

  # Neofetch
  neofetch = readFile ./neofetch/config.conf;

  # Document Templates
  templates = ./templates;

  # X11 Gestures
  touchegg = readFile ./touchegg/touchegg.conf;

  # Wallpapers
  wallpapers = ./wallpapers;

  # XORG Display Server
  xorg = readFile ./xorg/xresources;

  # Z Shell
  zsh =
  {
    message = readFile ./zsh/message;
    prompt = readFile ./zsh/p10k.zsh;
  };
}
