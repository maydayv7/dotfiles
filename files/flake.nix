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

      # Set PATH for SystemD Services
      systemd = ''export PATH="''${XDG_BIN_HOME}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"'';
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

    # Hyfetch
    fetch = readFile ./fetch/config.conf;

    # Geany Text Editor
    geany = map.files {
      directory = ./geany;
      apply = readFile;
      extension = ".conf";
    };

    # X11 Touchpad Gestures
    gestures = readFile ./touchegg/gestures.xml;

    # 'git' Version Control
    git.hooks = ./git/hooks;

    # GNOME Desktop
    gnome =
      {
        iso = readFile ./gnome/iso;
        settings = ./gnome/settings;
        shell = readFile ./gnome/shell.css;
        tiling = readFile ./gnome/tiling.css;
      }
      // map.files {
        directory = ./gnome;
        extension = ".json";
      };

    # GPG Keys Directory
    gpg = "/etc/gpg";

    # GTK+ Settings
    gtk.bookmarks = readFile ./gtk/bookmarks;

    # Hyprland WM
    hyprland = {
      # Keybinds Viewer
      kebihelp = readFile ./hyprland/kebihelp.json;

      # Clipboard Manager
      clipse = map.files {
        directory = ./hyprland/clipse;
        apply = readFile;
        extension = ".json";
      };

      # Application Drawer
      drawer = readFile ./hyprland/drawer.css;

      # Greeter Configuration
      greeter = readFile ./hyprland/greeter.conf;

      # Pyprland
      pypr = readFile ./hyprland/pypr.toml;

      # Waybar
      waybar = readFile ./hyprland/waybar.css;

      # WLogout
      wlogout = readFile ./hyprland/wlogout.css;
    };

    # Pictures
    images.profile = ./images/Profile.png;

    # Configuration Mutability
    mutability = rec {
      src = "https://gist.githubusercontent.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa/raw/41e569ba110eb6ebbb463a6b1f5d9fe4f9e82375";
      module = {
        url = src + "/mutability.nix";
        sha256 = "4b5ca670c1ac865927e98ac5bf5c131eca46cc20abf0bd0612db955bfc979de8";
      };

      vscode = {
        url = src + "/vscode.nix";
        sha256 = "fed877fa1eefd94bc4806641cea87138df78a47af89c7818ac5e76ebacbd025f";
      };
    };

    # Pantheon Desktop
    pantheon = {
      dconf = ./pantheon/dconf.nix;

      # Plank Dock
      plank = {
        autostart = readFile ./pantheon/plank/dock.desktop;
        launchers = ./pantheon/plank/launchers;
        theme = readFile ./pantheon/plank/dock.theme;
      };
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

    # ULauncher Application Launcher
    ulauncher =
      map.files {
        directory = ./ulauncher/settings;
        apply = readFile;
        extension = ".json";
      }
      // {
        themes = ./ulauncher/themes;
        extensions = ./ulauncher/extensions;
      };

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
      settings =
        {directory = ./xfce/settings;}
        // map.files {
          directory = ./xfce/settings;
          apply = readFile;
          extension = ".xml";
        };
    };

    # My Personal Website
    website = ../site;

    # XORG Display Server
    xorg = readFile ./xorg/Xresources;

    # Z Shell
    zsh.prompt = readFile ./zsh/p10k.zsh;
  };

  perSystem = _: {
    # Formatting Errors
    treefmt.config.programs.prettier.excludes = ["files/xfce/gtk.css"];
  };
}
