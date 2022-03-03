{
  config,
  options,
  lib,
  inputs,
  files,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib) mkAfter mkForce mkIf mkMerge mkOption optional types;
  inherit (config.hardware) filesystem;
in {
  imports = [inputs.impermanence.nixosModule];

  options = with types; {
    hardware.filesystem = mkOption {
      description = "Disk File System Choice";
      type = nullOr (enum ["simple" "advanced"]);
      default = null;
    };

    environment.persist = {
      files = mkOption {
        description = "Additional System Files to Preserve";
        type = listOf str;
        default = [];
        example = ["/etc/machine-id"];
      };

      dirs = mkOption {
        description = "Additional System Directories to Preserve";
        type = listOf str;
        default = [];
        example = ["/etc/nixos"];
      };
    };

    user.persist = {
      files = mkOption {
        description = "Additional User Files to Preserve";
        type = listOf str;
        default = [];
        example = [".bash_history"];
      };

      dirs = mkOption {
        description = "Additional User Directories to Preserve";
        type = listOf (either str attrs);
        default = [];
        example = ["Downloads"];
      };
    };
  };

  ## File System Configuration ##
  config =
    {
      warnings = optional (filesystem == null)
      (options.hardware.filesystem.description + " is unset");
    }
    // mkIf (filesystem != null) (mkMerge [
      {
        ## Partitions ##
        # Common Partitions
        boot.supportedFilesystems = ["ntfs" "vfat"];
        fileSystems = {
          # EFI System Partition
          "/boot" = {
            device = "/dev/disk/by-partlabel/ESP";
            fsType = "vfat";
          };

          # DATA Partition
          "/data/files" = {
            device = "/dev/disk/by-partlabel/Files";
            fsType = "ntfs";
            options = ["rw" "uid=1000"];
          };
        };

        # SWAP Partition
        swapDevices = [{device = "/dev/disk/by-partlabel/swap";}];
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

          # PERSISTENT Partition
          "/data" = {
            device = "fspool/data";
            fsType = "zfs";
            neededForBoot = true;
          };
        };

        # Boot Settings
        boot = {
          supportedFilesystems = ["zfs"];
          kernelParams = ["elevator=none" "nohibernate"];
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
        sops.gnupg.home = mkForce "/nix/state${files.gpg}";
        environment.persistence = {
          "/nix/state" = {
            files = ["/etc/machine-id"] ++ config.environment.persist.files;
            directories =
              ["/etc/nixos" "/var/log" "/var/lib/AccountsService"]
              ++ config.environment.persist.dirs;
          };

          "/data" = {
            hideMounts = true;
            users = mapAttrs (name: _: {
              inherit (config.user.persist) files;
              directories =
                [
                  "Desktop"
                  "Documents"
                  "Downloads"
                  "Music"
                  "Pictures"
                  "Projects"
                  "Public"
                  "Videos"
                  ".local/share/Trash"
                  {
                    directory = ".local/share/keyrings";
                    mode = "0700";
                  }
                ]
                ++ config.user.persist.dirs;
            })
            config.user.settings;
          };
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
