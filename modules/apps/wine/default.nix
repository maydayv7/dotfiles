{ config, lib, pkgs, ... }:
let
  enable = builtins.elem "wine" config.apps.list;
  wrap = import ./wrapper.nix { inherit pkgs; };
in {
  ## Discord Configuration ##
  config = lib.mkIf enable {
    # Firmware
    services.samba.enable = true;
    hardware.opengl.driSupport32Bit = true;

    # Utilities
    user.persist.dirs =
      [ ".cache/lutris" ".config/lutris" ".local/share/lutris" ".wine" ];

    environment.systemPackages = with pkgs; [
      lutris
      playonlinux
      gaming.wine-tkg
      winetricks
    ];
  };
}
