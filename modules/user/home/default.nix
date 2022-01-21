{ config, ... }:
let
  version = config.system.stateVersion;
  nixConf = config.environment.etc."nix/nix.conf".source;
in rec {
  config = {
    user.home = {
      home.stateVersion = version;
      home.file.".config/nix/nix.conf".source = nixConf;
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
        };
      };
    };
  };
}
