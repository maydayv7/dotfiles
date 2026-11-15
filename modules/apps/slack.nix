## Slack Configuration ##
{
  flake.modules.homeManager.slack = {pkgs, ...}: {
    home = {
      packages = [pkgs.slack];
      persist.directories = [".config/Slack"];
    };
  };
}
