## OSU! ##
_: {
  flake.modules.nixos.osu = {pkgs, ...}: {
    environment.systemPackages = [pkgs.osu-lazer-bin];
    user.homeConfig.home.persist.directories = [".local/share/osu"];
  };
}
