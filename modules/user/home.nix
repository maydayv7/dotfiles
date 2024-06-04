{
  config,
  lib,
  files,
  ...
}: {
  ## User Home Configuration ##
  config = {
    # Environment Settings
    environment.sessionVariables = {
      "XDG_CACHE_HOME" = "$HOME/.cache";
      "XDG_CONFIG_HOME" = "$HOME/.config";
      "XDG_DATA_HOME" = "$HOME/.local/share";
      "XDG_BIN_HOME" = "$HOME/.local/bin";
    };

    user.homeConfig = {
      imports = [
        ../../users

        # Mutable Configuration Files
        ({config, ...}: (import (builtins.fetchurl {
          inherit (files.mutability.module) url sha256;
        }) {inherit config lib;}))
      ];

      # SystemD User Services
      systemd.user = {
        enable = true;
        startServices = true;
      };

      # Package Configuration
      home = {
        inherit (config.system) stateVersion;
        file = {
          ".config/nixpkgs/config.nix".source = ../nix/config.nix;
          ".config/nix/nix.conf".source = config.environment.etc."nix/nix.conf".source;
        };
      };
    };
  };
}
