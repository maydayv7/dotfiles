{ lib, ... }:
{
  ## EXT4 File System Configuration ##
  # Partitions
  fileSystems =
  {
    # ROOT Partition
    "/" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "ext4";
    };
  };
}
