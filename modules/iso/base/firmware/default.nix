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
    # Audio
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Filesystems
    boot.supportedFilesystems = [ "btrfs" "vfat" "ntfs" ];

    environment.systemPackages = with pkgs;
    [
      # Device Firmware
      alsa-firmware
      firmwareLinuxNonfree
      sof-firmware

      # Installer Packages
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
