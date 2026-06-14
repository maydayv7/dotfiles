## Syncthing Configuration ##
# ? # Configure via Web UI: http://localhost:8384
{
  flake.modules.homeManager.syncthing = {
    services.syncthing.enable = true;
    home.persist.directories = [
      ".config/syncthing"
      ".local/state/syncthing"
    ];
  };
}
