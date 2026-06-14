{config, ...}: {
  ## Minecraft Server
  specialisation.minecraft.configuration = {
    system.nixos.label = "special.minecraft";
    games.mc-servers = let
      shared = {
        gamemode = "survival";
        difficulty = "normal";
        online-mode = false;
        server-ip = "0.0.0.0";
        spawn-protection = 0;
      };
    in [
      {
        type = "fabric";
        memory = 16;
        port = 25565;
        vc-port = 24454;
        config =
          shared
          // {
            motd = "My World";
          };
      }
      {
        type = "skyblock";
        memory = 10;
        port = 25567;
        config =
          shared
          // {
            motd = "Modded Skyblock";
            allow-flight = true;
          };
      }
    ];

    # VPN Tunnel
    environment.persist.directories = ["/var/lib/tailscale"];
    services.tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.sops.secrets."tailscale.secret".path;
    };
  };
}
