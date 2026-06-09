## Streaming Configuration ##
_: {
  flake.modules = {
    nixos.stream = {pkgs, ...}: {
      environment.systemPackages = [pkgs.stremio-linux-shell];
    };

    homeManager.stream = _: {
      home.persist.directories = [
        ".stremio-server"
        ".local/share/stremio"
      ];
    };
  };
}
