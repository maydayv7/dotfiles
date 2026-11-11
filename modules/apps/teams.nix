## Microsoft Teams Configuration ##
{
  flake.modules.homeManager.teams = {pkgs, ...}: {
    home.packages = [pkgs.teams-for-linux];
    home.persist.directories = [".config/teams-for-linux"];
  };
}
