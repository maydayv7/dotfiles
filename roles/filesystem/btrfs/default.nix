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
    # BTRFS Partition
    "/mnt/btrfs" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvolid=5" "compress=zstd" "autodefrag" "noatime" ];
    };
    # HOME Subvolume
    "/home" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };
    # NIX Subvolume
    "/nix" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };
    # PERSISTENT Subvolume
    "/persist" =
    {
      device = "/dev/disk/by-label/System";
      fsType = "btrfs";
      options = [ "subvol=persist" ];
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
  
  # Snapshots
  services.btrbk =
  {
    instances =
    {
      home =
      {
        onCalendar = "daily";
        settings =
        {
          timestamp_format = "long";
          snapshot_preserve = "31d";
          snapshot_preserve_min = "7d";
          volume."/mnt/btrfs".subvolume =
          {
            home.snapshot_create = "always";
          };
        };
      };
    };
  };
}
