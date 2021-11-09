{ config, lib, pkgs, ... }:
let
  cfg = config.base.enable;
in rec
{
  ## Installer Packages ##
  config = lib.mkIf (cfg == true)
  {
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
