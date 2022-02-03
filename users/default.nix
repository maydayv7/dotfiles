{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
  inherit (config) home;
in rec {
  options.credentials = {
    name = mkOption {
      description = "Work User Name";
      type = types.str;
      default = home.username;
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
