## Streaming Configuration ##
{ ... }:
{
  flake.modules = {
    nixos.stream =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.stremio-linux-shell ];
      };

    homeManager.stream = { ... }: {
      home.persist.directories = [
        ".stremio-server"
        ".local/share/stremio"
      ];
    };
  };
}
