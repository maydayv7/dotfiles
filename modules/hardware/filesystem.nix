{
  config,
  options,
  lib,
  inputs,
  pkgs,
  files,
  ...
}: let
  inherit (builtins) listToAttrs mapAttrs;
  inherit
    (lib)
    filterAttrs
    hasPrefix
    mkAliasOptionModule
    mkIf
    mkMerge
    mkOption
    nameValuePair
    optional
    types
    ;
  inherit (config.hardware) filesystem;
in {
  imports =
    [inputs.impermanence.nixosModule]
    ++ [
      (mkAliasOptionModule ["environment" "persist"] ["environment" "persistence" files.persist])
    ];

  options = with types; {
    hardware.filesystem = mkOption {
      description = "Disk File System Choice";
      type = nullOr (enum ["simple" "advanced"]);
      default = null;
    };

    user.persist = {
      files = mkOption {
        description = "Additional User Files to Preserve";
        type = listOf str;
        default = [];
        example = [".bash_history"];
      };

      directories = mkOption {
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
      warnings =
        optional (filesystem == null)
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
        fileSystems =
          {
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
          }
          // filterAttrs (name: _: hasPrefix "/etc" name)
          (listToAttrs (map (item: nameValuePair item.directory {neededForBoot = true;})
              config.environment.persist.directories));

        # Boot Settings
        boot = {
          resumeDevice = "/dev/disk/by-partlabel/swap";
          supportedFilesystems = ["zfs"];
          kernelParams = ["elevator=none" "nohibernate"];
          zfs = {
            forceImportRoot = false;
            forceImportAll = false;
            devNodes = "/dev/disk/by-partlabel/System";
          };

          # Opt-In State
          initrd.systemd = {
            enable = true;
            services.rollback = {
              description = "Wipe ZFS partition for Opt-In State Configuration";
              wantedBy = ["initrd.target"];
              after = ["zfs-import-fspool.service"];
              before = ["sysroot.mount"];
              path = [pkgs.zfs];
              unitConfig.DefaultDependencies = "no";
              serviceConfig.Type = "oneshot";
              script = ''
                zfs rollback -r fspool/system/root@blank && echo "Rollback Complete!"
              '';
            };
          };
        };

        # Persisted Files
        environment.persistence = {
          "${files.persist}" = {
            files = ["/etc/machine-id"];
            directories = [
              {
                directory = "/etc/nixos";
                group = "keys";
                mode = "774";
              }
              "/var/log"
              "/var/lib/AccountsService"
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
            ];
          };

          "/data" = {
            hideMounts = true;
            users =
              mapAttrs (name: _: {
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
                  ++ config.user.persist.directories;
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
