## FreeFileSync Configuration ##
{
  flake.modules.homeManager.freefilesync = {pkgs, ...}: {
    home.packages = [pkgs.freefilesync];
    home.persist.directories = [".config/FreeFileSync"];
  };
}
