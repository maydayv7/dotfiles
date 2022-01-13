{ config, lib, pkgs, files, ... }:
let enable = (builtins.elem "discord" config.apps.list);
in {
  ## Discord Configuration ##
  config = lib.mkIf enable {
    environment.systemPackages = with pkgs; [ betterdiscordctl discord ];

    user.home.home = {
      # Plugins
      file.".config/BetterDiscord/plugins" = {
        source = files.discord.plugins;
        recursive = true;
      };

      # Discord Activation  
      activation.discordSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        FILE=~/.config/BetterDiscord
        if [ -e "$FILE" ];
        then
          echo "Discord setup already over"
        else
          echo "Setting up Discord..."
          $DRY_RUN_CMD /usr/bin/env betterdiscordctl install
        fi
      '';
    };
  };
}
