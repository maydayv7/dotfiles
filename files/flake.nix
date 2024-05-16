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
      # Binds
      binds = ./hyprland/binds.pango;

      # Clipboard Manager
      clipse = map.files {
        directory = ./hyprland/clipse;
        apply = readFile;
        extension = ".json";
      };

      # Greeter Configuration
      greeter = readFile ./hyprland/greeter.conf;

      # NWG Shell
      nwg =
        map.files {
          directory = ./hyprland/nwg;
          apply = readFile;
          extension = ".css";
        }
        // {
          image = ./hyprland/nwg/dropdown.svg;
        };

      # Pyprland
      pypr = readFile ./hyprland/pypr.toml;

      # Waybar
      waybar = readFile ./hyprland/waybar.css;

      # WLogout
      wlogout = readFile ./hyprland/wlogout.css;
    };

    # Pictures
    images.profile = ./images/Profile.png;

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
