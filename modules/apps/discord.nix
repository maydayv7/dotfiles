{
  config,
  lib,
  pkgs,
  files,
  ...
}: let
  enable = builtins.elem "discord" config.apps.list;
in {
  ## Discord Configuration ##
  config = lib.mkIf enable {
    environment.systemPackages = with pkgs; [betterdiscordctl discord];

    user = {
      persist.directories = [".config/BetterDiscord" ".config/discord"];
      homeConfig.home = {
        # Plugins
        file.".config/BetterDiscord/plugins" = {
          source = files.proprietary.discord;
          recursive = true;
        };

        # Discord Activation
        activation.discordSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
          echo "Setting up Discord..."
          $DRY_RUN_CMD /usr/bin/env betterdiscordctl $VERBOSE_ARG install || true
        '';
      };
    };
  };
}
