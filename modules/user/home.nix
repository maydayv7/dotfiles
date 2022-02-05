{ config, ... }: {
  ## User Home Configuration ##
  config = {
    # Environment
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
      home.stateVersion = config.system.stateVersion;
      home.file.".config/nix/nix.conf".source =
        config.environment.etc."nix/nix.conf".source;
    };
  };
}
