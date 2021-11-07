{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  #W Device Firmware ##
  config = mkIf (cfg == true)
  {
    # Device Firmware
    hardware.enableRedistributableFirmware = true;

    # Audio
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Network Settings
    networking =
    {
      networkmanager.enable = true;
      firewall.enable = false;
    };

    # Filesystems
    boot.supportedFilesystems = [ "btrfs" "vfat" "ntfs" ];

    # Installer Packages
    environment.systemPackages = with pkgs;
    [
      efibootmgr
      efivar
      git
      git-crypt
      gparted
      killall
      nano
      parted
      unzip
      wget
      zip
    ];
  };
}
