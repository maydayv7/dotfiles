{ config, lib, pkgs, modulesPath, ... }:
{
  fileSystems =
  { 
    "/" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "ext4";
    };
    "/boot/efi" =
    {
      device = "/dev/disk/by-partlabel/boot";
      fsType = "vfat";
    };
    "/data" =
    {
      device = "/dev/disk/by-label/Files";
      fsType = "ntfs";
      options = [ "rw" "uid=1000"];
    };
  };
  swapDevices =
  [ { device = "/dev/disk/by-label/swap"; } ];
}
