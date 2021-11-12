{ config, lib, inputs, pkgs, ... }:
let
  iso = config.iso.enable;
in rec
{
  ## Base Install Media Configuration ##
  config = lib.mkIf iso
  {
    # Installer Packages
    environment.systemPackages = with pkgs;
    [
      efibootmgr
      efivar
      gparted
      killall
      parted
    ];
  };
}
