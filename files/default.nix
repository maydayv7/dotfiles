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

  # Neofetch
  fetch = readFile ./neofetch/config.conf;

  # Custom Fonts
  fonts =
  {
    path = ./fonts;
    config = readFile ./fonts/fontconfig;
  };

  # X11 Gestures
  gestures = readFile ./touchegg/touchegg.conf;

  # GNOME Desktop
  gnome =
  {
    accounts = readFile ./gnome/accounts.conf;
    bookmarks = readFile ./gnome/bookmarks;
    shell = readFile ./gnome/gnome-shell.css;
    syntax = readFile ./gnome/nix.lang;
    theme = readFile ./gnome/tango-dark.xml;
  };

  # Document Templates
  templates = ./templates;

  # Wallpapers
  wallpapers = ./wallpapers;

  # XORG Display Server
  xorg = readFile ./xorg/Xresources;

  # Z Shell
  zsh =
  {
    message = readFile ./zsh/message;
    prompt = readFile ./zsh/p10k.zsh;
  };
}
