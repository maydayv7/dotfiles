## Zoom Configuration ##
{
  flake.modules.homeManager.zoom = {pkgs, ...}: {
    home.packages = [pkgs.zoom-us];
    home.persist = {
      files = [".config/zoomus.conf"];
      directories = [
        ".zoom"
        ".cache/zoom"
      ];
    };
  };
}
