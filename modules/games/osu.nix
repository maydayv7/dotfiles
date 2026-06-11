## OSU! ##
_: {
  flake.modules = {
    nixos.osu = {pkgs, ...}: {
      environment.systemPackages = [pkgs.osu-lazer-bin];
    };
    homeManager.osu.home.persist.directories = [".local/share/osu"];
  };
}
