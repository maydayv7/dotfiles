## Minecraft Server Configuration ##
# ? # Run 'systemctl start minecraft-server-NAME' to start the server
# ? # Run 'echo COMMAND > /run/minecraft/NAME.stdin' to run commands
{inputs, ...}: {
  flake.modules.nixos.mc-server = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit
      (builtins)
      listToAttrs
      toString
      ;
    inherit
      (lib)
      concatMap
      filter
      mkIf
      mkMerge
      mkOption
      types
      ;
    inherit (pkgs) fetchurl fetchzip linkFarmFromDrvs;

    cfg = config.games.mc-servers;
    dataDir = "/srv/minecraft";

    # Mods
    modData = import ./_mods.nix;
    mkMods = srv: loader: let
      mods = filter (m: !(m ? require) || (m.require == "vc-port" && srv.vc-port != null)) loader.mods;
    in
      linkFarmFromDrvs "mods" (map (m: fetchurl {inherit (m) name url hash;}) mods);
  in {
    imports = [inputs.minecraft.nixosModules.minecraft-servers];

    options.games.mc-servers = mkOption {
      description = "List of Minecraft Servers";
      default = [];
      type = types.listOf (
        types.submodule (
          {config, ...}: {
            options = {
              name = mkOption {
                description = "Unique server name";
                type = types.str;
                default = config.type;
              };

              type = mkOption {
                description = "Server Type";
                type = types.enum [
                  "fabric"
                  "skyblock"
                ];
                default = "fabric";
              };

              memory = mkOption {
                description = "Memory (GB) allocated to server";
                type = types.int;
                default = 12;
              };

              config = mkOption {
                description = "Server Properties";
                type = types.attrs;
                default = {};
              };

              port = mkOption {
                description = "Main server TCP port";
                type = types.int;
                default = 25565;
              };

              vc-port = mkOption {
                description = "Port for Simple Voice Chat";
                type = with types; nullOr int;
                default = null;
              };
            };
          }
        )
      );
    };

    config = mkIf (cfg != []) {
      system.fs.persist.directories = [dataDir];
      networking.firewall = {
        allowedTCPPorts = map (srv: srv.port) cfg;
        allowedUDPPorts = concatMap (srv:
          if (srv.vc-port != null)
          then [srv.vc-port]
          else [])
        cfg;
      };

      services.minecraft-servers = {
        enable = true;
        inherit dataDir;
        eula = true;
        openFirewall = true;
        managementSystem = {
          tmux.enable = false;
          systemd-socket.enable = true;
        };

        servers = listToAttrs (
          map (srv: {
            inherit (srv) name;
            value = mkMerge [
              {
                enable = true;
                autoStart = false;
                serverProperties = srv.config // {server-port = srv.port;};
                jvmOpts = let
                  mem = toString srv.memory;
                in "-Xms${mem}G -Xmx${mem}G --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15";
              }

              ## Fabric Server
              (mkIf (srv.type == "fabric") {
                package = pkgs.fabricServers.fabric-26_1_2;
                symlinks.mods = mkMods srv modData.fabric;
              })

              ## Modded Skyblock Server
              (mkIf (srv.type == "skyblock") (
                let
                  inherit (inputs.minecraft.lib) collectFilesAt;

                  # Ozone Skyblock Reborn 2
                  modpack = fetchzip {
                    url = "https://mediafilez.forgecdn.net/files/8061/293/OSR%201.5.4%20-%20Server.zip";
                    sha256 = "sha256-L9bh+MbKgKeD+RezVkmUWSK7kFiUSZrDyPLp7MrPXAY=";
                  };
                in {
                  package = pkgs.neoforgeServers.neoforge-1_21_1;
                  files = (collectFilesAt modpack "config") // (collectFilesAt modpack "kubejs");
                  symlinks = collectFilesAt modpack "mods";
                }
              ))
            ];
          })
          cfg
        );
      };
    };
  };
}
