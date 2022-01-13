let
  inherit (builtins) readFile;
in
{
  ## dotfiles ##
  # Configuration Directory
  path = "/etc/nixos";

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
    dconf = ./gnome/dconf.nix;
    shell = readFile ./gnome/gnome-shell.css;
    syntax = readFile ./gnome/nix.lang;
    theme = readFile ./gnome/tango-dark.xml;
  };

  # GPG Keys Directory
  gpg = "/etc/nixos/secrets/unencrypted/gpg";

  # Document Templates
  templates = ./templates;

  # Wallpapers
  wallpapers = ./wallpapers;

  # XDG Settings
  xdg.mime = ./xdg/mime.nix;

  # XORG Display Server
  xorg = readFile ./xorg/Xresources;

  # Z Shell
  zsh =
  {
    lol = readFile ./zsh/lol;
    prompt = readFile ./zsh/p10k.zsh;
  };
}
