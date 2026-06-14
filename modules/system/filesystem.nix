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
      inherit (config.system.fs) scheme;
    in {
      imports = [
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

      options.system.fs.scheme = mkOption {
        description = "Disk Filesystem Scheme";
        type = with types;
          nullOr (enum [
            "simple"
            "advanced"
          ]);
        default = null;
      };

      config = mkMerge [
        {
          warnings = optional (scheme == null) "Disk Filesystem Scheme is unset";
          boot = {
            supportedFilesystems = {
              ntfs = true;
              vfat = true;
              zfs = true;
            };
            zfs.forceImportRoot = false;
          };
        }

        ## Common Partitions
        (mkIf (scheme != null) {
          programs.fuse.userAllowOther = true;

          # EFI System Partition
          fileSystems."/boot" = {
            device = "/dev/disk/by-partlabel/ESP";
            fsType = "vfat";
          };

          # SWAP Partition
          swapDevices = [{device = "/dev/disk/by-partlabel/swap";}];
          boot.kernel.sysctl."vm.swappiness" = 1;

          system.activationScripts.dotfiles = with files.path; let
            path =
              if scheme == "advanced"
              then "${persist}/"
              else "";
            dir = "${path}${system}";
          in ''
            chown root:keys ${dir}
            chmod 774 -R ${dir}
          '';
        })

        ## Simple File System Configuration using EXT4 ##
        (mkIf (scheme == "simple") {
          # ROOT Partition
          fileSystems."/" = {
            device = "/dev/disk/by-partlabel/System";
            fsType = "ext4";
          };
        })

        {
          environment.persist.enable = mkDefault false;
          system.fs.persist.enable = mkDefault false;
        }

        ## Advanced File System Configuration using ZFS ##
        (mkIf (scheme == "advanced") (
          let
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
                "${files.path.data}" = {
                  device = "fspool/data";
                  fsType = "zfs";
                  neededForBoot = true;
                };
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
              resumeDevice = "/dev/disk/by-partlabel/swap";
              # Boot Settings
              kernelParams = ["elevator=none"];
              zfs = {
                forceImportAll = false;
                unsafeAllowHibernation = true;
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
                "/var/lib/systemd/coredump"
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
