## Calibre E-Book Manager ##
{
  flake.modules.homeManager.calibre = {pkgs, ...}: {
    home.packages = [pkgs.calibre];
    home.persist.directories = [
      ".calibre"
      ".config/calibre"
    ];
  };
}
