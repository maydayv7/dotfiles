{ config, lib, inputs, ... }:
let
  inherit (lib) mkIf mkMerge mkOption types;
  filesystem = config.hardware.filesystem;
in rec
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.hardware.filesystem = mkOption
  {
    description = "Disk File System Configuration";
    type = types.enum [ "simple" "advanced" ];
    default = "simple";
  };

  ## File System Configuration ##
  config = mkIf (filesystem == "simple" || filesystem == "advanced")
  (mkMerge
  [
    {
      ## Partitions ##
      # Common Partitions
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
          device = "/dev/disk/by-partlabel/Files";
          fsType = "ntfs";
          options = [ "rw" "uid=1000" ];
        };
      };

      # SWAP Partition
      swapDevices =
      [ { device = "/dev/disk/by-partlabel/swap"; } ];
      boot.kernel.sysctl."vm.swappiness" = 1;
    }

    ## Simple File System Configuration using EXT4 ##
    (mkIf (filesystem == "simple")
    {
      fileSystems =
      {
        # ROOT Partition
        "/" =
        {
          device = "/dev/disk/by-partlabel/System";
          fsType = "ext4";
        };
      };
    })

    ## Advanced File System Configuration using BTRFS ##
    (mkIf (filesystem == "advanced")
    {
      fileSystems =
      {
        # ROOT Partition
        # Opt-in State with TMPFS
        "/" =
        {
          device = "tmpfs";
          fsType = "tmpfs";
          options = [ "defaults" "size=2G" "mode=755" ];
        };

        # BTRFS Partition
        "/mnt/btrfs" =
        {
          device = "/dev/disk/by-partlabel/System";
          fsType = "btrfs";
          options = [ "subvolid=5" "compress=zstd" "autodefrag" "noatime" ];
        };

        # HOME Subvolume
        "/home" =
        {
          device = "/dev/disk/by-partlabel/System";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };

        # NIX Subvolume
        "/nix" =
        {
          device = "/dev/disk/by-partlabel/System";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };

        # PERSISTENT Subvolume
        "/persist" =
        {
          device = "/dev/disk/by-partlabel/System";
          fsType = "btrfs";
          options = [ "subvol=persist" ];
          neededForBoot = true;
        };
      };

      # Persisted Files
      environment.persistence."/persist" =
      {
        files = [ "/etc/machine-id" ];
        directories =
        [
          "/etc/nixos"
          "/etc/NetworkManager/system-connections"
          "/etc/ssh"
          "/var/log"
          "/var/lib/AccountsService"
          "/var/lib/bluetooth"
          "/var/lib/libvirt"
        ];
      };

      # Snapshots
      services.btrbk =
      {
        instances =
        {
          home =
          {
            onCalendar = "hourly";
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
  ]);
}
