## File System Configuration ##
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.filesystem = {
      config,
      lib,
      pkgs,
      ...
    }: let
      inherit
        (lib)
        filterAttrs
        hasPrefix
        mkAliasOptionModule
        mkDefault
        mkIf
        mkMerge
        mkOption
        nameValuePair
        optional
        types
        ;
      inherit (builtins) listToAttrs map;
      cfg = config.system.fs;
    in {
      imports = [
        inputs.disko.nixosModules.disko
        inputs.impermanence.nixosModule
        (
          mkAliasOptionModule
          ["environment" "persist"]
          [
            "environment"
            "persistence"
            files.path.persist
          ]
        )
        (
          mkAliasOptionModule
          ["system" "fs" "persist"]
          [
            "environment"
            "persistence"
            files.path.data
          ]
        )
      ];

      options.system.fs = {
        scheme = mkOption {
          description = "Disk Filesystem Scheme";
          type = with types;
            nullOr (enum [
              "simple"
              "advanced"
            ]);
          default = null;
        };

        disk = mkOption {
          description = "Target Disk for Installation";
          type = types.str;
          default = "/dev/disk/by-id/disko-placeholder";
          example = "/dev/disk/by-id/nvme-eui.0123456789abcdef";
        };

        swap = mkOption {
          description = "Size of SWAP Partition";
          type = types.str;
          default = "8G";
          example = "16G";
        };
      };

      config = mkMerge [
        {
          warnings = optional (cfg.scheme == null) "Disk Filesystem Scheme is unset";
          boot = {
            supportedFilesystems = {
              ntfs = true;
              vfat = true;
              zfs = true;
            };
            zfs.forceImportRoot = false;
          };

          environment.persist.enable = mkDefault false;
          system.fs.persist.enable = mkDefault false;

          ## Disk Layout
          disko.devices = mkMerge [
            (mkIf (cfg.scheme != null) {
              disk.main = {
                type = "disk";
                device = cfg.disk;
                content = {
                  type = "gpt";
                  partitions = {
                    # EFI System Partition
                    ESP = {
                      label = "ESP";
                      type = "EF00";
                      size = "1024M";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                        mountOptions = ["umask=0077"];
                      };
                    };

                    # SWAP Partition
                    swap = {
                      label = "swap";
                      size = cfg.swap;
                      content = {
                        type = "swap";
                        resumeDevice = true;
                      };
                    };

                    # System Partition
                    System = {
                      label = "System";
                      size = "100%";
                      content =
                        if cfg.scheme == "advanced"
                        then {
                          type = "zfs";
                          pool = "fspool";
                        }
                        else {
                          type = "filesystem";
                          format = "ext4";
                          mountpoint = "/";
                        };
                    };
                  };
                };
              };
            })

            (mkIf (cfg.scheme == "advanced") {
              zpool.fspool = {
                type = "zpool";
                options.cachefile = "none";
                rootFsOptions = {
                  compression = "zstd";
                  encryption = "on";
                  keyformat = "passphrase";
                  keylocation = "prompt";
                  mountpoint = "none";
                  xattr = "sa";
                  acltype = "posixacl";
                };

                datasets = {
                  # ROOT Dataset
                  "system/root" = {
                    type = "zfs_fs";
                    mountpoint = "/";
                    options.mountpoint = "legacy";
                    postCreateHook = "zfs snapshot fspool/system/root@blank";
                  };

                  # NIX Store Dataset
                  "system/nix" = {
                    type = "zfs_fs";
                    mountpoint = "/nix";
                    options = {
                      mountpoint = "legacy";
                      atime = "off";
                    };
                  };

                  # Persisted Dataset
                  "data" = {
                    type = "zfs_fs";
                    mountpoint = files.path.data;
                    options = {
                      mountpoint = "legacy";
                      "com.sun:auto-snapshot" = "true";
                    };
                  };

                  # Reserved space
                  # ? # Free with 'zfs set refreservation=none fspool/reserve'
                  "reserve" = {
                    type = "zfs_fs";
                    options = {
                      canmount = "off";
                      mountpoint = "none";
                      refreservation = "1G";
                    };
                  };
                };
              };
            })
          ];
        }

        (mkIf (cfg.scheme != null) {
          programs.fuse.userAllowOther = true;
          boot.kernel.sysctl."vm.swappiness" = 1; # SWAP Behaviour

          system.activationScripts.dotfiles = with files.path; let
            path =
              if cfg.scheme == "advanced"
              then "${persist}/"
              else "";
            dir = "${path}${system}";
          in ''
            chown root:keys ${dir}
            chmod 774 -R ${dir}
          '';
        })

        ## Advanced File System Configuration using ZFS ##
        (mkIf (cfg.scheme == "advanced") (
          let
            rollback = ''
              zfs rollback -r fspool/system/root@blank && echo "Rollback Complete!"
            '';
          in {
            fileSystems =
              {
                "${files.path.data}".neededForBoot = true;
              }
              // filterAttrs (name: _: hasPrefix "/etc" name) (
                listToAttrs (
                  map (
                    item:
                      nameValuePair item.directory {
                        device = "${files.path.persist}${item.directory}";
                        fsType = "none";
                        options = ["bind"];
                        neededForBoot = true;
                      }
                  )
                  config.environment.persist.directories
                )
              );

            # Early Boot Requirements
            boot = {
              # Boot Settings
              kernelParams = ["elevator=none"];
              zfs = {
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

            # Persisted Files
            system.fs.persist.enable = true;
            environment.persistence."${files.path.persist}" = {
              enable = true;
              files = ["/etc/machine-id"];
              directories = [
                files.path.system
                "/var/log"
                "/var/lib/AccountsService"
                "/var/lib/nixos"
                "/var/lib/systemd"
              ];
            };
          }
        ))
      ];
    };

    homeManager.filesystem = {
      lib,
      pkgs,
      osConfig ? null,
      ...
    }: let
      advanced = osConfig != null && osConfig.system.fs.scheme == "advanced";
    in {
      imports = [(lib.mkAliasOptionModule ["home" "persist"] ["home" "persistence" files.path.data])];

      home.persistence."${files.path.data}" = {
        enable = advanced;
        allowTrash = true;
        hideMounts = true;
        directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Videos"
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }
        ];
      };

      # Persist Trash Folder
      systemd.user.services.persist-trash = lib.mkIf advanced {
        Unit.Description = "Persist Trash Folder";
        Install.WantedBy = ["default.target"];
        Service = let
          run = script:
            lib.getExe (
              pkgs.writeShellApplication {
                name = "script";
                runtimeInputs = [pkgs.coreutils];
                text = ''
                  LOCAL="$HOME/.local/share/Trash"
                  PERSIST="${files.path.data}/home/$USER/Trash"
                  mkdir -p "$LOCAL"
                  ${script}
                '';
              }
            );
        in {
          Type = "oneshot";
          RemainAfterExit = true;
          StandardOutput = "journal";
          ExecStart = run ''
            if [ -d "$PERSIST" ]
            then
              cp -r "$PERSIST"/. "$LOCAL"
              rm -rf "$PERSIST"
            fi
          '';
          ExecStop = run ''
            mkdir -p "$PERSIST"
            cp -r "$LOCAL"/. "$PERSIST"
          '';
        };
      };
    };
  };
}
