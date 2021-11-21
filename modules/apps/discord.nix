{ config, files, username, lib, inputs, pkgs, ... }:
let
  enable = config.apps.discord.enable;
  desktop = config.gui.desktop;
in
{
  options.apps.discord.enable = lib.mkEnableOption "Enable Discord Chat";

  ## Discord Configuration ##
  config = lib.mkIf enable
  {
    environment.systemPackages = with pkgs;
    [
      betterdiscordctl
      discord
    ];

    home-manager.users."${username}".home =
    {
      # Plugins
      file.".config/BetterDiscord/plugins" =
      {
        source = files.discord.plugins;
        recursive = true;
      };

      # Discord Activation  
      activation.discordSetup = inputs.home.lib.hm.dag.entryAfter ["writeBoundary"]
      ''
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
