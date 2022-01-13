{ config, lib, pkgs, files, ... }:
let
  enable = config.user.password == "";
  homeDir = "/home/${config.user.name}";
  version = config.system.stateVersion;
in rec {
  ## User Home Configuration ##
  config = lib.mkIf enable {
    user.home = {
      home.stateVersion = version;
      home.packages = with pkgs; [ home-manager ];
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

      # Wallpapers
      home.file.".local/share/backgrounds".source = files.wallpapers;
    };
  };
}
