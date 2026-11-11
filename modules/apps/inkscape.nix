## Inkscape Vector Editor ##
{
  flake.modules.homeManager.inkscape = {pkgs, ...}: {
    home.packages = [pkgs.inkscape];
    home.persist.directories = [".config/inkscape"];
  };
}
