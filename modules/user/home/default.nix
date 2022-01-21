{ config, pkgs, files, ... }:
let version = config.system.stateVersion;
in rec {
  config = {
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
            XDG_PROJECTS_DIR = "$HOME/Projects";
            XDG_TBD_DIR = "$HOME/Documents/TBD";
            XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
          };
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
