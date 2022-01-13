with ({ inherit (builtins) readFile; }); {
  ## Dotfiles ##
  # File Paths
  path = {
    toplevel = ./.;
    system = "/etc/nixos";
    cache = "maydayv7-dotfiles";
    repo = "https://gitlab.com/maydayv7/dotfiles";
    mirror = "https://github.com/maydayv7/dotfiles";
  };

  # Useful Commands
  commands = readFile ../scripts/commands.sh;

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

  # 'sops' Encrypted Secrets
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
    colors = readFile ./zsh/colors.sh;
    lol = readFile ./zsh/lol;
    prompt = readFile ./zsh/p10k.zsh;
  };
}
