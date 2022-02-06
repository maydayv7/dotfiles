{ config, lib, ... }:
let
  inherit (builtins) attrValues map;
  inherit (lib) id mkIf mkOption types util;
in {
  options.credentials = {
    name = mkOption {
      description = "Work User Name";
      type = types.str;
      default = config.home.username;
    };

    mail = mkOption {
      description = "User Mail ID";
      type = types.str;
      default = "";
    };

    key = mkOption {
      description = "User GPG Key";
      type = types.str;
      default = "";
    };
  };

  ## Home Configuration ##
  config = {
    # GPG Settings
    programs.gpg.publicKeys = map (source: {
      inherit source;
      trust = "ultimate";
    }) (attrValues (util.map.files ../secrets/keys id ".gpg"));

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
          XDG_TBD_DIR = "$HOME/Documents/TBD";
          XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
        };
      };
    };
  };
}
