{ config, lib, ... }:
let
  cfg = config.hardware.filesystem;
in rec
{
  options.hardware.filesystem = lib.mkOption
  {
    description = "File System to be used by the disk";
    type = lib.types.enum [ "btrfs" "ext4" ];
    default = "ext4";
  };

  ## File System Configuration ##
  config = lib.mkMerge
  [
    {
      ## Partitions ##
      # Base Partitions
      fileSystems =
      {
        # EFI System Partition
        "/boot" =
        {
          device = "/dev/disk/by-partlabel/ESP";
          fsType = "vfat";
        };
        # DATA Partition
        "/data" =
        {
          device = "/dev/disk/by-label/Files";
          fsType = "ntfs";
          options = [ "rw" "uid=1000" ];
        };
      };

      # SWAP Partition
      swapDevices =
      [ { device = "/dev/disk/by-label/swap"; } ];
      # SWAP Usage
      boot.kernel.sysctl."vm.swappiness" = 1;
    }

    ## EXT4 File System Configuration ##
    (lib.mkIf (cfg == "ext4")
    {
      fileSystems =
      {
        "/" =
        {
          device = "/dev/disk/by-label/System";
          fsType = "ext4";
        };
      };
    })

    ## BTRFS Opt-in State File System Configuration ##
    (lib.mkIf (cfg == "btrfs")
    {
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
    })
  ];
}
