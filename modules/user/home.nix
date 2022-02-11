{ config, ... }: {
  ## User Home Configuration ##
  config = {
    # Environment Settings
    user.persist.dirs = [ "Projects" ];
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };

    user.home = {
      imports = [ ../../users ];
      systemd.user.startServices = true;

      # Package Configuration
      home.stateVersion = config.system.stateVersion;
      home.file = {
        ".config/nixpkgs/config.nix".source = ../nix/config.nix;
        ".config/nix/nix.conf".source =
          config.environment.etc."nix/nix.conf".source;
      };
    };
  };
}
