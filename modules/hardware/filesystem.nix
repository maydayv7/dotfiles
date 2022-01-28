{ config, options, lib, inputs, files, ... }:
let
  inherit (lib) mkAfter mkForce mkIf mkMerge mkOption types;
  opt = options.hardware.filesystem.description;
  inherit (config.hardware) filesystem;
  inherit (config.filesystem) persist;
in rec {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options = {
    hardware.filesystem = mkOption {
      description = "Disk File System Choice";
      type = types.nullOr (types.enum [ "simple" "advanced" ]);
      default = null;
    };

    filesystem.persist = {
      files = mkOption {
        description = "Additional System Files to Preserve";
        type = types.listOf types.str;
        default = [ ];
      };

      dirs = mkOption {
        description = "Additional System Directories to Preserve";
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  ## File System Configuration ##
  config = {
    warnings = if (filesystem == null) then [ (opt + " is unset") ] else [ ];
  } // mkIf (filesystem != null) (mkMerge [
    {
      ## Partitions ##
      # Common Partitions
      boot.supportedFilesystems = [ "ntfs" "vfat" ];
      fileSystems = {
        # EFI System Partition
        "/boot" = {
          device = "/dev/disk/by-partlabel/ESP";
          fsType = "vfat";
        };

        # DATA Partition
        "/data" = {
          device = "/dev/disk/by-partlabel/Files";
          fsType = "ntfs";
          options = [ "rw" "uid=1000" ];
        };
      };

      # SWAP Partition
      swapDevices = [{ device = "/dev/disk/by-partlabel/swap"; }];
      boot.kernel.sysctl."vm.swappiness" = 1;
    }

    ## Simple File System Configuration using EXT4 ##
    (mkIf (filesystem == "simple") {
      fileSystems = {
        # ROOT Partition
        "/" = {
          device = "/dev/disk/by-partlabel/System";
          fsType = "ext4";
        };
      };
    })

    ## Advanced File System Configuration using BTRFS ##
    (mkIf (filesystem == "advanced") {
      fileSystems = {
        # ROOT Partition
        "/" = {
          device = "fspool/system/root";
          fsType = "zfs";
        };

        # NIX Partition
        "/nix" = {
          device = "fspool/system/nix";
          fsType = "zfs";
        };

        # HOME Partition
        "/home" = {
          device = "fspool/data/home";
          fsType = "zfs";
        };

        # PERSISTENT Partition
        "/persist" = {
          device = "fspool/data/persist";
          fsType = "zfs";
          neededForBoot = true;
        };
      };

      # Boot Settings
      boot = {
        supportedFilesystems = [ "zfs" ];
        kernelParams = [ "elevator=none" "nohibernate" ];
        zfs = {
          forceImportRoot = false;
          forceImportAll = false;
          devNodes = "/dev/disk/by-partlabel/System";
        };

        # Opt-In State
        initrd.postDeviceCommands = mkAfter ''
          zfs rollback -r fspool/system/root@blank
        '';
      };

      # Persisted Files
      sops.gnupg.home = mkForce "/persist${files.gpg}";
      environment.persistence."/persist" = {
        files = [ "/etc/machine-id" ] ++ persist.files;
        directories = [ "/etc/nixos" "/var/log" "/var/lib/AccountsService" ]
          ++ persist.dirs;
      };

      # Maintainence
      services.zfs = {
        trim.enable = true;
        autoScrub.enable = true;
        autoSnapshot = {
          enable = true;
          hourly = 12;
          daily = 7;
          weekly = 3;
          monthly = 1;
        };
      };
    })
  ]);
}
