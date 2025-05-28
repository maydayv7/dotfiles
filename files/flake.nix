{
  util,
  inputs,
  ...
}:
{
  ## Program Configuration and 'dotfiles' ##
  flake.files =
    let
      inherit (util) build map;
      inherit (builtins) fromJSON readFile;
    in
    rec {
      # File Paths
      path = {
        toplevel = ./.;

        system = "/etc/nixos"; # Configuration Directory
        persist = "/nix/state"; # Persisted Files

        gpg = "/etc/gpg"; # GPG Keys Directory
        sops = ../secrets/secrets.yaml; # Encrypted Secrets

        cache = "maydayv7-dotfiles";
        flake = "github:maydayv7/dotfiles";
        repo = "https://github.com/maydayv7/dotfiles";
      };

      # Interactive Nix Shell
      # To explore syntax and configuration
      repl = ./repl.nix;

      # ASCII Art
      ascii = map.files {
        directory = ./ascii;
        extension = "";
        recursive = true;
      };

      # Directory Bookmarks
      bookmarks = ''
        file:///data/files Files
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

      # X11 Touchpad Gestures
      gestures = readFile ./touchegg.xml;

      # 'git' Version Control
      git.hooks = ./git/hooks;

      # GNOME Desktop
      gnome = map.files {
        directory = ./gnome;
        extension = ".json";
      };

      # Hyprland WM
      hyprland =
        {
          # Pyprland
          pypr = readFile ./hyprland/pypr.toml;

          # Hot Corners
          waycorner = readFile ./hyprland/waycorner.toml;

          # Keybinds Viewer
          kebihelp = readFile ./hyprland/kebihelp.json;

          # PcmanFM File Manager
          pcmanfm = readFile ./hyprland/pcmanfm.conf;

          # Greeter Configuration
          greeter = readFile ./hyprland/greeter.conf;
        }
        // map.files {
          directory = ./hyprland/theme;
          apply = readFile;
          extension = ".css";
        };

      # Pictures
      images = {
        profile = ./images/Profile.png;
        transparent = ./images/transparent.png;
      };

      # Logseq Notes
      logseq = {
        settings = ./logseq/settings;
        prefs = readFile ./logseq/preferences.json;
      };

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

      # Nano Text Editor
      nano = readFile ./nanorc;

      # Custom Proprietary Files
      proprietary = inputs.proprietary.files;
      inherit (proprietary) wallpapers;

      # Bash Scripts
      scripts = map.files {
        directory = ../scripts;
        apply = build.script;
        extension = ".sh";
      };

      # Document Templates
      templates = ./templates;

      # Visual Studio Code Editor
      vscode = map.files {
        directory = ./vscode;
        apply = file: fromJSON (readFile file);
        extension = ".json";
      };

      # My Personal Website
      website = ../site;
    };
}
