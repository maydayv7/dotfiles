{ config, lib, pkgs, ... }:
let enable = (builtins.elem "wine" config.apps.list);
in {
  ## Discord Configuration ##
  config = lib.mkIf enable {
    # Firmware
    services.samba.enable = true;
    hardware.opengl.driSupport32Bit = true;

    # Utilities
    environment.systemPackages = with pkgs; [
      lutris
      playonlinux
      gaming.wine-tkg
      winetricks
    ];
  };
}
