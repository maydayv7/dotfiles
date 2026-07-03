## Games Configuration ##
_: {
  flake.modules = {
    nixos.games = {lib, ...}: {
      # Steam
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      # Game Mode
      # ? # Use 'gamemoderun <command>'
      hardware.cpu.mode = lib.mkOverride 51 "performance";
      programs.gamemode.enable = true;
      hardware.steam-hardware.enable = true;
    };

    homeManager.games = {
      lib,
      osConfig ? {},
      ...
    }: {
      # Lutris
      programs.lutris = {
        enable = true;
        steamPackage = osConfig.programs.steam.package;
        winePackages = lib.optional ((osConfig.apps.wine or null) != null) osConfig.apps.wine;
      };

      home.persist.directories = [
        "Games"

        # Lutris
        ".cache/lutris"
        ".config/lutris"
        ".local/share/lutris"

        # Steam
        ".local/share/applications"
        ".local/share/icons/hicolor"
        ".steam"
        ".local/share/Steam"
      ];
    };
  };
}
