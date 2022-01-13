with ({ inherit (builtins) readFile; }); {
  ## Dotfiles ##
  # Files Path
  toplevel = ./.;

  # 'git' Repository
  repo = "https://gitlab.com/maydayv7/dotfiles";
  mirror = "https://github.com/maydayv7/dotfiles";

  # Configuration Directory
  path = "/etc/nixos";

  # Discord Chat
  discord = {
    plugins = ./discord/plugins;
    theme = readFile ./discord/theme.css;
  };

  # Neofetch
  fetch = readFile ./neofetch/config.conf;

  # Custom Fonts
  fonts = {
    path = ./fonts;
    config = readFile ./fonts/fontconfig;
  };

  # X11 Gestures
  gestures = readFile ./touchegg/touchegg.conf;

  # GNOME Desktop
  gnome = {
    accounts = readFile ./gnome/accounts.conf;
    bookmarks = readFile ./gnome/bookmarks;
    dconf = ./gnome/dconf.nix;
    shell = readFile ./gnome/gnome-shell.css;
    syntax = readFile ./gnome/nix.lang;
    theme = readFile ./gnome/tango-dark.xml;
  };

  # GPG Keys Directory
  gpg = "/etc/nixos/files/gpg";

  # Interactive Nix Shell
  repl = ../repl.nix;

  # Bash Scripts
  scripts.commands = readFile ../scripts/commands.sh; # Useful Commands

  # `sops` Encrypted Secrets
  sops = ../secrets/.sops.yaml;

  # Document Templates
  templates = ./templates;

  # Wallpapers
  wallpapers = ./wallpapers;

  # XDG Settings
  xdg.mime = ./xdg/mime.nix;

  # XORG Display Server
  xorg = readFile ./xorg/Xresources;

  # Z Shell
  zsh = {
    lol = readFile ./zsh/lol;
    prompt = readFile ./zsh/p10k.zsh;
  };
}
