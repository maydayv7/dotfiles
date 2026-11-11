## Media Utilities ##
{
  flake.modules.homeManager.media = {pkgs, ...}: {
    home.packages = with pkgs; [
      popsicle
      drawing
      identity
      vipsdisp
    ];
  };
}
