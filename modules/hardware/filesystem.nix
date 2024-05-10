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
    mkAfter
    mkAliasOptionModule
    mkForce
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
      (mkAliasOptionModule ["environment" "persist"] ["environment" "persistence" files.path.persist])
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
        programs.fuse.userAllowOther = true;
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

      ## Advanced File System Configuration using ZFS ##
      (mkIf (filesystem == "advanced") (let
        rollback = ''
          zfs rollback -r fspool/system/root@blank && echo "Rollback Complete!"
        '';
      in {
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
          kernelParams = ["elevator=none"];
          zfs = {
            allowHibernation = true;
            forceImportRoot = false;
            forceImportAll = false;
            devNodes = "/dev/disk/by-partlabel/System";
          };

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
              script = rollback;
            };
          };
        };

        # Debug
        specialisation.recovery.configuration = {
          boot.initrd = {
            systemd.enable = mkForce false;
            postDeviceCommands = mkAfter rollback;
          };
        };

        # Persisted Files
        environment.persistence = {
          "${files.path.persist}" = {
            files = ["/etc/machine-id"];
            directories = [
              files.path.system
              "/var/log"
              "/var/lib/AccountsService"
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
            ];
          };

          "/data" = {
            hideMounts = true;
            users =
              mapAttrs (_: _: {
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

        system.activationScripts.dotfiles = let
          dir = with files.path; "${persist}/${system}";
        in ''
          chown root:keys ${dir}
          chmod 774 -R ${dir}
        '';

        user.homeConfig.systemd.user.services.persist-trash = {
          Unit.Description = "Persist Trash Folder";
          Install.WantedBy = ["default.target"];
          Service = let
            dir = ''
              LOCAL="$HOME/.local/share/Trash"
              PERSIST="/data/home/$USER/Trash"
              mkdir -p "$LOCAL"
            '';
          in {
            Type = "oneshot";
            RemainAfterExit = true;
            StandardOutput = "journal";
            ExecStart = "${pkgs.writeShellApplication {
              name = "retrieve";
              runtimeInputs = [pkgs.coreutils];
              text = ''
                ${dir}
                if [ -d "$PERSIST" ]
                then
                  cp -r "$PERSIST"/. "$LOCAL"
                  rm -rf "$PERSIST"
                fi
              '';
            }}/bin/retrieve";
            ExecStop = "${pkgs.writeShellApplication {
              name = "migrate";
              runtimeInputs = [pkgs.coreutils];
              text = ''
                ${dir}
                mkdir -p "$PERSIST"
                cp -r "$LOCAL"/. "$PERSIST"
              '';
            }}/bin/migrate";
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
      }))
    ]);
}
