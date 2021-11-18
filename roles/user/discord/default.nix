{ lib, inputs, pkgs, ... }:
{
  ## Discord Configuration ##
  home.packages = with pkgs;
  [
    betterdiscordctl
    discord
  ];

  home.file =
  {
    # Theme
    ".config/BetterDiscord/data/stable/custom.css".source = ./theme;

    # Plugins
    ".config/BetterDiscord/plugins" =
    {
      source = ./plugins;
      recursive = true;
    };
  };

  # Discord Activation  
  home.activation.discordSetup = inputs.home.lib.hm.dag.entryAfter ["writeBoundary"]
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
}
