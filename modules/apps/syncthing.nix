## Syncthing Configuration ##
# ? # Configure via Web UI: http://localhost:8384
{
  flake.modules.nixos.syncthing = {
    networking.firewall = {
      allowedTCPPorts = [22000];
      allowedUDPPorts = [21027 22000];
    };
  };

  flake.modules.homeManager.syncthing = {
    services.syncthing.enable = true;
    home.persist.directories = [
      ".config/syncthing"
      ".local/state/syncthing"
    ];
  };
}
