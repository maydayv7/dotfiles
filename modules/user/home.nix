{ config, lib, pkgs, files, ... }:
let
  enable = !config.user.minimal;
  homeDir = config.user.directory;
  version = config.system.stateVersion;
in rec {
  ## User Home Configuration ##
  config = lib.mkIf enable {
    user.home = {
      home.stateVersion = version;
      home.packages = [ pkgs.home-manager ];
      systemd.user.startServices = true;

      # XDG Configuration
      xdg = {
        enable = true;
        mime.enable = true;
        mimeApps.enable = true;
        configFile."mimeapps.list".force = true;

        # Default Home Folders
        cacheHome = "${homeDir}/.cache";
        configHome = "${homeDir}/.config";
        dataHome = "${homeDir}/.local/share";
        stateHome = "${homeDir}/.local/state";

        # User Home Folders
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
          extraConfig = { XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots"; };
        };
      };

      home.file = {
        # Profile Picture
        ".face".source = files.images.profile;

        # Wallpapers
        ".local/share/backgrounds".source = files.images.wallpapers;
      };
    };
  };
}
