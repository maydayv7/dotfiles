{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (util) build map;
  inherit (builtins) fromJSON readFile;
in {
  flake.files = rec {
    # File Paths
    path = {
      toplevel = ./.;

      system = "/etc/nixos";
      persist = "/nix/state";
      data = "/data";

      gpg = "/etc/gpg";
      sops = ../secrets/secrets.yaml;

      cache = "maydayv7-dotfiles";
      flake = "github:maydayv7/dotfiles";
      repo = "https://github.com/maydayv7/dotfiles";
    };

    # Interactive Nix Shell
    repl = ./repl.nix;

    # ASCII Art
    ascii = map.files {
      directory = ./ascii;
      extension = "";
      recursive = true;
    };

    # Directory Bookmarks
    bookmarks = ''
      file://${path.data}/files Files
      file://${path.data}/sync Sync
      file:/// Computer
    '';

    # Base16 Color Schemes
    colors = map.files {
      directory = ./colors;
      extension = ".yaml";
    };

    # Fastfetch
    fetch = readFile ./fastfetch.jsonc;

    # Geany Text Editor
    geany = map.files {
      directory = ./geany;
      apply = readFile;
      extension = ".conf";
    };

    # 'git' Version Control
    git.hooks = ./git/hooks;

    # Gitea Code Hosting
    gitea = map.files {
      directory = ./gitea;
      apply = readFile;
      extension = ".css";
    };

    # GNOME Desktop
    gnome = map.files {
      directory = ./gnome;
      extension = ".json";
    };

    # Hyprland WM
    hyprland =
      {
        shaders = ./hyprland/shaders;
        pypr = readFile ./hyprland/pypr.toml;
        waycorner = readFile ./hyprland/waycorner.toml;
        kebihelp = readFile ./hyprland/kebihelp.json;
        greeter = readFile ./hyprland/greeter.conf;
      }
      // map.files {
        directory = ./hyprland/theme;
        apply = readFile;
        extension = ".css";
      };

    # Pictures
    images = map.files {
      directory = ./images;
      extension = ".png";
    };

    # Logseq Notes
    logseq = {
      settings = ./logseq/settings;
      prefs = readFile ./logseq/preferences.json;
    };

    # Nano Text Editor
    nano = readFile ./nanorc;

    # PcmanFM File Manager
    pcmanfm = readFile ./pcmanfm.conf;

    # Custom Proprietary Files
    proprietary = inputs.proprietary.files;
    inherit (proprietary) wallpapers;

    # Bash Scripts
    scripts = map.files {
      directory = ../scripts;
      apply = build.script;
      extension = ".sh";
    };

    # Display Temperature Control
    sunsetr = ./sunsetr;

    # Notifications Daemon
    swaync = readFile ./swaync.css;

    # Document Templates
    templates = ./templates;

    # Terminal Multiplexer
    tmux = readFile ./tmuxrc.tmux;

    # Visual Studio Code Editor
    vscode = map.files {
      directory = ./vscode;
      apply = file: fromJSON (readFile file);
      extension = ".json";
    };

    # My Personal Website
    website = ../site;

    # Logout Menu
    wlogout = readFile ./wlogout.css;

    # YouTube
    youtube = readFile ./ytmusic.json;
  };
}
