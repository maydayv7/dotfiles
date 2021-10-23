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
    # LOGS Subvolume
    "/var/log" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "autodefrag" "noatime" ];
      neededForBoot = true;
    };
    # LIBRARY Subvolume
    "/var/lib" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=lib" "compress=zstd" "autodefrag" "noatime" ];
    };
  };
  
  # Persisted Files
  environment.etc =
  {
    nixos.source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    machine-id.source = "/persist/etc/machine-id";
  };
}
