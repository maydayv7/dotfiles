{ config, lib, inputs, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  # Install Media Build Module
  imports = [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" ];

  ## Install Media Package Configuration ##
  config = mkIf (cfg == true)
  {
    # ISO Creation Settings
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;
    environment.pathsToLink = [ "/libexec" ];

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
