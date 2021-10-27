{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.hardware.filesystem;
in rec
{
  options.hardware.filesystem = mkOption
  {
    type = types.enum [ "btrfs" "ext4" ];
    description = "This is the File System to be used by the disk";
    default = "ext4";
  };
  
  config =
  {
    # Partitions
    fileSystems = (if (cfg == "ext4")
    then
    ## EXT4 File System Configuration ##
    {
      "/" =
      {
        device = "/dev/disk/by-label/System";
        fsType = "ext4";
      };
    }
    else
    ## BTRFS Opt-in State File System Configuration ##
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
    });
    
    # Persisted Files
    environment.persistence."/persist" = (mkIf (cfg == "btrfs")
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
    });
    
    # Snapshots
    services.btrbk = (mkIf (cfg == "btrfs")
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
    });
  };
}
