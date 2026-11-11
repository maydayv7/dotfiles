## GIMP Image Editor ##
{
  flake.modules.homeManager.gimp = {pkgs, ...}: {
    home.packages = [pkgs.gimp3];
    home.persist.directories = [
      ".config/GIMP"
      ".cache/gimp"
    ];
  };
}
