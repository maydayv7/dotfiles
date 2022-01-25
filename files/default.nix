{ lib, inputs }:
let
  none = lib.id;
  inherit (lib.util) map;
  inherit (builtins) readFile;
in {
  ## Dotfiles ##
  # File Paths
  path = {
    toplevel = ./.;
    system = "/etc/nixos";
    cache = "maydayv7-dotfiles";
    flake = "github:maydayv7/dotfiles";
    repo = "https://github.com/maydayv7/dotfiles";
  };

  # ASCII Art
  ascii = map.files' ./ascii none "";

  # Discord Chat
  discord = {
    plugins = "${inputs.discord}/plugins";
    theme = readFile ./discord/theme.css;
  };

  # Neofetch
  fetch = readFile ./neofetch/config.conf;

  # Firefox Web Browser
  firefox.theme = ''@import "${inputs.firefox}/userChrome.css";'';

  # Custom Fonts
  fonts = {
    path = inputs.fonts;
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
    profile = ./images/Profile.png;
    wallpapers = ./images/wallpapers;
  };

  # Nano Text Editor
  nano = readFile ./nano/nanorc;

  # Interactive Nix Shell
  repl = ../repl.nix;

  # Bash Scripts
  scripts = map.files ../scripts readFile ".sh";

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
