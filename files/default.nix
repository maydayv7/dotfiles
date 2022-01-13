with ({ inherit (builtins) readFile; }); {
  ## Dotfiles ##
  # File Paths
  path = {
    toplevel = ./.;
    system = "/etc/nixos";
    cache = "maydayv7-dotfiles";
    flake = "gitlab:maydayv7/dotfiles";
    repo = "https://gitlab.com/maydayv7/dotfiles";
    mirror = "https://github.com/maydayv7/dotfiles";
  };

  # ASCII Art
  ascii = {
    lol = readFile ./ascii/lol;
    pacman = readFile ./ascii/pacman;
    tux = readFile ./ascii/tux;
  };

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

  # Pictures
  images = {
    wallpapers = ./wallpapers;
    profile = ./wallpapers/Profile.png;
  };

  # Nano Text Editor
  nano = readFile ./nano/nanorc;

  # Interactive Nix Shell
  repl = ../repl.nix;

  # Bash Scripts
  scripts = {
    colors = readFile ../scripts/colors.sh;
    commands = readFile ../scripts/commands.sh;
    mail = readFile ../scripts/mail.sh;
    partitions = readFile ../scripts/partitions.sh;
  };

  # 'sops' Encrypted Secrets
  sops = ../secrets/.sops.yaml;

  # Document Templates
  templates = ./templates;

  # XDG Settings
  xdg.mime = ./xdg/mime.nix;

  # XORG Display Server
  xorg = readFile ./xorg/Xresources;

  # Z Shell
  zsh.prompt = readFile ./zsh/p10k.zsh;
}
