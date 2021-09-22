{ config, lib, pkgs, modulesPath, ... }:
{
  fileSystems =
  {
    # ROOT Partition
    "/" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "ext4";
    };
    # EFI System Partition
    "/boot/efi" =
    {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
    };
    # DATA Partition
    "/data" =
    {
      device = "/dev/disk/by-label/Files";
      fsType = "ntfs";
      options = [ "rw" "uid=1000"];
    };
  };
  # SWAP Partition
  swapDevices =
  [ { device = "/dev/disk/by-label/swap"; } ];
}
