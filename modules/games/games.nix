## Games Configuration ##
_: {
  flake.modules = {
    nixos.games = {
      lib,
      pkgs,
      ...
    }: {
      # Packages
      environment.systemPackages = with pkgs; [
        bottles
        lutris
      ];

      # Steam
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      # Game Mode
      hardware.cpu.mode = lib.mkOverride 51 "performance"; # Use 'gamemoderun %command%'
      programs.gamemode.enable = true;
      hardware.steam-hardware.enable = true;
    };

    homeManager.games = {
      config,
      lib,
      ...
    }: {
      # Runner
      xdg.dataFile."lutris/runners/wine/wine-system" =
        lib.mkIf (config.apps.wine.package or null != null)
        {
          source = config.apps.wine.package;
        };

      # Directories
      home.persist.directories = [
        "Games"
        ".local/share/bottles"

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
