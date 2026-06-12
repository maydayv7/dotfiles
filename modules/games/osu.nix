## OSU! ##
_: {
  flake.modules.homeManager.osu = {pkgs, ...}: {
    home.packages = [pkgs.osu-lazer-bin];
    home.persist.directories = [".local/share/osu"];
  };
}
