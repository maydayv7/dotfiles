{ config, ... }:
let
  version = config.system.stateVersion;
  nixConf = config.environment.etc."nix/nix.conf".source;
in rec {
  ## User Home Configuration ##
  config = {
    # Environment
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };

    user.home = {
      imports = [ ../../users ];
      home.stateVersion = version;
      home.file.".config/nix/nix.conf".source = nixConf;
      systemd.user.startServices = true;
    };
  };
}
