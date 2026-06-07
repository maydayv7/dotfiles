# User management and home-manager integration
## USER Configuration ##
{ config, inputs, ... }:
let
  files = config.flake.files;
  util = config.util;
in
{
  flake.modules = {
    # Shared user base config (imported into NixOS as part of home-manager setup)
    nixos.user =
      { config, lib, pkgs, ... }:
      let
        inherit (lib) mkDefault mkOption types;
      in
      {
        imports = [ inputs.home-manager.nixosModules.home-manager ];

        config = {
          users.mutableUsers = false;
          users.extraUsers.root = {
            isNormalUser = false;
            extraGroups = [ "wheel" ];
          };

          # Home Manager settings
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = { }; # intentionally empty - use closures
          };

          # XDG directories
          environment.sessionVariables = {
            "XDG_CACHE_HOME" = "$HOME/.cache";
            "XDG_CONFIG_HOME" = "$HOME/.config";
            "XDG_DATA_HOME" = "$HOME/.local/share";
            "XDG_BIN_HOME" = "$HOME/.local/bin";
          };
        };
      };

    # Global Home Manager Configuration
    homeManager.user =
      { config, lib, pkgs, ... }:
      {
        imports = [
          # Mutable file support
          (import ../users/_mutable.nix)
        ];

        # Update News
        news.display = "show";
        # User Services
        systemd.user = {
          enable = true;
          startServices = true;
        };

        # Environment Settings
        home.file = {
          ".local/share/backgrounds".source = files.wallpapers.path;
          ".config/gtk-3.0/bookmarks" = {
            text = lib.mkBefore ''
              file://${config.home.homeDirectory}/Downloads Downloads
              file://${config.home.homeDirectory}/Pictures Pictures
              file://${config.home.homeDirectory}/Documents Documents
            '';
            force = true;
          };
        };

        programs.gpg = {
          publicKeys =
            builtins.map
              (source: {
                inherit source;
                trust = "ultimate";
              })
              (
                builtins.attrValues (
                  util.map.files {
                    directory = ../../secrets/keys;
                    extension = ".gpg";
                  }
                )
              );
        };

        xdg = {
          enable = true;
          mime.enable = true;
          mimeApps.enable = true;
          configFile."mimeapps.list".force = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            desktop = "$HOME/Desktop";
            documents = "$HOME/Documents";
            download = "$HOME/Downloads";
            music = "$HOME/Music";
            pictures = "$HOME/Pictures";
            publicShare = "$HOME/Public";
            templates = "$HOME/Templates";
            videos = "$HOME/Videos";
            extraConfig."XDG_SCREENSHOTS_DIR" = "$HOME/Pictures/Screenshots";
          };
        };
      };
  };
}
