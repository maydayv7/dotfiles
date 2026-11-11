## Pitivi Video Editor ##
{
  flake.modules.homeManager.pitivi = {pkgs, ...}: {
    home.packages = [pkgs.pitivi];
    home.persist.directories = [".config/pitivi"];
  };
}
