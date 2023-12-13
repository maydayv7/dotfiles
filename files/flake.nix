{
  util,
  inputs,
  ...
}: {
  ## Program Configuration and 'dotfiles' ##
  flake.files = let
    inherit (util) build map;
    inherit (builtins) fromJSON readFile;
  in rec {
    # File Paths
    path = {
      toplevel = ./.;

      system = "/etc/nixos"; # Configuration Directory
      persist = "/nix/state"; # Persisted Files

      cache = "maydayv7-dotfiles";
      flake = "github:maydayv7/dotfiles";
      repo = "https://github.com/maydayv7/dotfiles";
    };

    # ASCII Art
    ascii = map.files {
      directory = ./ascii;
      extension = "";
      recursive = true;
    };

    # Base16 Color Schemes
    colors = map.files {
      directory = ./colors;
      extension = ".yaml";
    };

    # Neofetch
    fetch = readFile ./neofetch/config.conf;

    # Firefox Web Browser
    firefox.theme = readFile ./firefox/userContent.css;

    # 'git' Version Control
    git.hooks = ./git/hooks;

    # GNOME Desktop
    gnome =
      {
        dconf = ./gnome/dconf.nix;
        iso = readFile ./gnome/iso;
        tiling = ./gnome/tiling.css;
      }
      // map.files {
        directory = ./gnome;
        extension = ".json";
      };

    # GPG Keys Directory
    gpg = "/etc/gpg";

    # GTK+ Settings
    gtk.bookmarks = readFile ./gtk/bookmarks;

    # Pictures
    images.profile = ./images/Profile.png;

    # Plank Dock
    plank = {
      autostart = readFile ./plank/dock.desktop;
      launchers = ./plank/launchers;
      theme = readFile ./plank/dock.theme;
    };

    # Custom Proprietary Files
    proprietary = inputs.proprietary.files;
    inherit (proprietary) wallpapers;

    # Nano Text Editor
    nano = readFile ./nano/nanorc;

    # Interactive Nix Shell
    repl = ./repl.nix;

    # Bash Scripts
    scripts = map.files {
      directory = ../scripts;
      apply = build.script;
      extension = ".sh";
    };

    # 'sops' Encrypted Secrets
    sops = ../secrets/secrets.yaml;

    # Document Templates
    templates = ./templates;

    # Visual Studio Code Editor
    vscode = map.files {
      directory = ./vscode;
      apply = file: fromJSON (readFile file);
      extension = ".json";
    };

    # XDG Settings
    xdg.mime = import ./xdg/mime.nix;

    # XFCE Desktop
    xfce = {
      css = readFile ./xfce/gtk.css;
      panel = ./xfce/panel;
      terminal = readFile ./xfce/terminalrc;
      settings = ./xfce/settings;
    };

    # My Personal Website
    website = ../site;

    # XORG Display Server
    xorg = readFile ./xorg/Xresources;

    # Z Shell
    zsh.prompt = readFile ./zsh/p10k.zsh;
  };
}
