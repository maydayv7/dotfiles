{
  config,
  lib,
  util,
  files,
  ...
}: let
  inherit (builtins) attrValues map;
  inherit (lib) mkBefore mkIf mkOption types;
  cfg = config.credentials.key;
in {
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

  ## Home Configuration ##
  config = {
    home.file = let
      dir = config.home.homeDirectory;
    in {
      # Wallpapers
      ".local/share/backgrounds".source = files.wallpapers.path;

      # GTK+ Bookmarks
      ".config/gtk-3.0/bookmarks".text = mkBefore ''
        file://${dir}/Downloads Downloads
        file://${dir}/Pictures Pictures
      '';
    };

    # GPG Settings
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
        map (source: {
          inherit source;
          trust = "ultimate";
        }) (attrValues (util.map.files {
          directory = ../secrets/keys;
          extension = ".gpg";
        }));
    };

    # XDG Configuration
    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps.enable = true;
      configFile."mimeapps.list".force = true;

      # User Home Directories
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

        # Custom Directories
        extraConfig = {
          "XDG_PROJECTS_DIR" = "$HOME/Projects";
          "XDG_SCREENSHOTS_DIR" = "$HOME/Pictures/Screenshots";
        };
      };
    };
  };
}
