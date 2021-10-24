{ lib, pkgs, ... }:
{
  ## BTRFS Opt-in State File System Configuration ##
  # Partitions
  fileSystems =
  {
    # ROOT Partition
    # Opt-in State with TMPFS
    "/" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=3G" "mode=755" ];
    };
    # HOME Subvolume
    "/home" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "autodefrag" "noatime" ];
    };
    # NIX Subvolume
    "/nix" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "autodefrag" "noatime" ];
    };
    # PERSISTENT Subvolume
    "/persist" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "autodefrag" "noatime" ];
      neededForBoot = true;
    };
  };
  
  # Persisted Files
  environment.persistence."/persist" =
  {
    directories =
    [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/AccountsService"
      "/var/lib/bluetooth"
      "/var/lib/libvirt"
    ];
    
    files =
    [
      "/etc/machine-id"
    ];
  };
}
