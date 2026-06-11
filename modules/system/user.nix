## User Configuration ##
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
  inherit (config) util;
in {
  flake.modules = {
    # Shared user base config (imported into NixOS as part of home-manager setup)
    nixos.user = {
      config,
      lib,
      ...
    }: let
      inherit
        (lib)
        getValues
        mkIf
        mkOption
        mkOptionType
        types
        ;

      # Merged Sets Type: every definition contributes a module
      mergedAttrs = mkOptionType {
        name = "mergedAttrs";
        merge = _: getValues;
      };
    in {
      imports = [inputs.home-manager.nixosModules.home-manager];

      # Shared User Home Configuration: collected from system modules and
      # applied to every user via 'home-manager.sharedModules' (no specialArgs)
      options.user.homeConfig = mkOption {
        description = "Shared User Home Configuration";
        type = mergedAttrs;
        default = {};
      };

      # Additional groups added to every normal user
      options.user.groups = mkOption {
        description = "Additional User Groups";
        type = types.listOf types.str;
        default = [];
      };

      config = {
        users.mutableUsers = false;
        users.extraUsers.root = {
          isNormalUser = false;
          extraGroups = ["wheel"];
          hashedPasswordFile =
            mkIf (
              config.sops.secrets ? "root.secret"
            )
            config.sops.secrets."root.secret".path;
        };

        # User Passwords (sops, available before user creation)
        sops.secrets = util.map.secrets {
          directory = ../../secrets/passwords;
          neededForUsers = true;
        };

        # Home Manager settings
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          extraSpecialArgs = {}; # intentionally empty - use closures
          sharedModules = config.user.homeConfig;
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
    homeManager.user = {
      config,
      lib,
      ...
    }: let
      inherit (lib) mkIf mkOption types;
      cfg = config.credentials;
    in {
      imports = [
        # Mutable file support
        (import ../users/_mutable.nix)
      ];

      # User Identity / Credentials
      options.credentials = {
        name = mkOption {
          description = "Work User Name";
          type = types.str;
          default = config.home.username;
        };

        fullname = mkOption {
          description = "Full User Name";
          type = types.str;
          default = "Default User";
        };

        mail = mkOption {
          description = "User Mail ID";
          type = types.str;
          default = "";
          example = "user@email.com";
        };

        key = mkOption {
          description = "User GPG Key";
          type = types.str;
          default = "";
          example = "Use 'gpg --list-signatures --keyid-format short'";
        };
      };

      config = {
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
          settings = mkIf (cfg.key != "") {
            default-key = cfg.key;
            default-recipient-self = true;
            auto-key-locate = "local,wkd,keyserver";
            keyserver = "hkps://keys.openpgp.org";
            auto-key-retrieve = true;
            auto-key-import = true;
            keyserver-options = "honor-keyserver-url";
          };

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
  };
}
