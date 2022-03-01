{
  lib,
  inputs,
}: let
  inherit (lib.util) map;
  inherit (builtins) readFile;
  proprietary = import ./proprietary;
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
  ascii = map.files' ./ascii lib.id "";

  # Discord Chat
  discord = {
    inherit (proprietary.discord) plugins;
    theme = readFile ./discord/theme.css;
  };

  # Neofetch
  fetch = readFile ./neofetch/config.conf;

  # Firefox Web Browser
  firefox.theme = readFile ./firefox/userContent.css;

  # Custom Fonts
  fonts = {
    path = proprietary.fonts;
    config = readFile ./fonts/fontconfig.xml;
  };

  # X11 Gestures
  gestures = readFile ./touchegg/touchegg.conf;

  # 'git' Version Control
  git.hooks = ./git/hooks;

  # GNOME Desktop
  gnome = {
    accounts = readFile ./gnome/accounts.conf;
    dconf = ./gnome/dconf.nix;
    shell = readFile ./gnome/gnome-shell.css;
    syntax = readFile ./gnome/nix.lang;
    theme = readFile ./gnome/tango-dark.xml;
  };

  # GPG Keys Directory
  gpg = "/etc/nixos/files/gpg";

  # GTK+ Settings
  gtk.bookmarks = readFile ./gtk/bookmarks;

  # Pictures
  images = {
    profile = ./images/Profile.png;
    wallpapers = ./images/wallpapers;
  };

  # Plank Dock
  plank = {
    autostart = readFile ./plank/dock.desktop;
    launchers = ./plank/launchers;
    theme = readFile ./plank/dock.theme;
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

  # XFCE Desktop
  xfce = {
    css = readFile ./xfce/gtk.css;
    settings = ./xfce/settings;
    terminal = readFile ./xfce/terminalrc;
  };

  # XORG Display Server
  xorg = readFile ./xorg/Xresources;

  # Z Shell
  zsh.prompt = readFile ./zsh/p10k.zsh;
}
