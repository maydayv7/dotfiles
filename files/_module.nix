{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
in {
  flake.files = rec {
    # File Paths
    path = rec {
      toplevel = ./.;

      system = "/etc/nixos";
      persist = "/nix/state";

      gpg = "/etc/gpg";
      sops = ../secrets/secrets.yaml;

      data = "/data";
      files = "${data}/files";
      sync = "${data}/sync";

      cache = "maydayv7-dotfiles";
      flake = "github:maydayv7/dotfiles";
      repo = "https://github.com/maydayv7/dotfiles";
    };

    # Interactive Nix Shell
    repl = ./repl.nix;

    # ASCII Art
    ascii = util.map.files {
      directory = ./ascii;
      extension = "";
      recursive = true;
    };

    # Directory Bookmarks
    bookmarks = ''
      file://${path.files} Files
      file://${path.sync} Sync
      file:/// Computer
    '';

    # Base16 Color Schemes
    colors = util.map.files {
      directory = ./colors;
      extension = ".yaml";
    };

    # Fastfetch
    fetch = builtins.readFile ./fastfetch.jsonc;

    # Geany Text Editor
    geany = util.map.files {
      directory = ./geany;
      apply = builtins.readFile;
      extension = ".conf";
    };

    # 'git' Version Control
    git.hooks = ./git/hooks;

    # Gitea Code Hosting
    gitea = util.map.files {
      directory = ./gitea;
      apply = builtins.readFile;
      extension = ".css";
    };

    # GNOME Desktop
    gnome = util.map.files {
      directory = ./gnome;
      extension = ".json";
    };

    # Hyprland WM
    hyprland = {
      shaders = ./hyprland/shaders;
      noctalia = ./hyprland/noctalia;
      pypr = builtins.readFile ./hyprland/pypr.toml;
      kebihelp = builtins.readFile ./hyprland/kebihelp.json;
    };

    # Pictures
    images = util.map.files {
      directory = ./images;
      extension = ".png";
    };

    # Password Manager
    keepassxc = builtins.readFile ./keepassxc.ini;

    # Nano Text Editor
    nano = builtins.readFile ./nanorc;

    # PcmanFM File Manager
    pcmanfm = builtins.readFile ./pcmanfm.conf;

    # Custom Proprietary Files
    proprietary = inputs.proprietary.files;
    inherit (proprietary) wallpapers;

    # Bash Scripts
    scripts = util.map.files {
      directory = ../scripts;
      apply = util.build.script;
      extension = ".sh";
    };

    # Document Templates
    templates = ./templates;

    # Visual Studio Code Editor
    vscode = util.map.files {
      directory = ./vscode;
      apply = file: builtins.fromJSON (builtins.readFile file);
      extension = ".json";
    };

    # My Personal Website
    website = ../site;

    # YouTube
    youtube = builtins.readFile ./ytmusic.json;

    # Zed Editor
    zed = util.map.files {
      directory = ./zed;
      apply = file: builtins.fromJSON (builtins.readFile file);
      extension = ".json";
    };
  };
}
