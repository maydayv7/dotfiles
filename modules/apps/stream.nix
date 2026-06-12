## Streaming Configuration ##
_: {
  flake.modules.homeManager.stream = {pkgs, ...}: {
    home.packages = [pkgs.stremio-linux-shell];
    home.persist.directories = [
      ".stremio-server"
      ".local/share/stremio"
    ];
  };
}
