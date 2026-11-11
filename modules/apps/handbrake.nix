## HandBrake Video Converter ##
{
  flake.modules.homeManager.handbrake = {pkgs, ...}: {
    home.packages = [pkgs.handbrake];
  };
}
