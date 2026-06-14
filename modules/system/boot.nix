## Boot Configuration ##
{inputs, ...}: {
  flake.modules.nixos.boot = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit
      (lib)
      mkDefault
      mkForce
      mkIf
      mkMerge
      mkOption
      optional
      types
      ;
    scheme = config.system.scheme;
  in {
    imports = [inputs.boot.nixosModules.lanzaboote];

    options.system.scheme = mkOption {
      description = "Supported Boot Firmware Scheme";
      type = types.nullOr (
        types.enum [
          "mbr"
          "efi"
          "secure"
        ]
      );
      default = "efi";
    };

    config =
      {warnings = optional (scheme == null) "Boot firmware is unknown";}
      // mkIf (scheme != null) (mkMerge [
        {
          boot = {
            tmp.cleanOnBoot = true;

            # Debug
            consoleLogLevel = 3;
            initrd.verbose = false;
            # Plymouth
            plymouth.enable = true;
            kernelParams = [
              "quiet"
              "splash"
              "boot.shell_on_fail"
              "rd.systemd.show_status=false"
              "rd.udev.log_level=3"
              "udev.log_priority=3"
            ];

            loader = {
              timeout = mkDefault 0;
              efi.canTouchEfiVariables = true;
              grub.enable = mkDefault false;
              systemd-boot.enable = mkDefault false;
            };
          };

          specialisation.recovery.configuration = {
            system.nixos.label = "special.recovery";
            boot = {
              initrd.verbose = mkForce true;
              plymouth.enable = mkForce false;
            };
          };
        }

        ## GRUB MBR Boot Loader ##
        (mkIf (scheme == "mbr") {
          boot.loader.grub = {
            enable = mkForce true;
            device = "nodev";
            efiSupport = true;
            zfsSupport = true;
            useOSProber = true;
            splashImage = null;
            extraConfig = "set timeout_style=hidden";
          };
        })

        ## SYSTEMD EFI Boot Loader ##
        (mkIf (scheme == "efi") {
          boot.loader.systemd-boot = {
            enable = mkForce true;
            editor = false;
            configurationLimit = 15;
          };
        })

        ## EFI Secure Boot ##
        (mkIf (scheme == "secure") rec {
          boot.lanzaboote = {
            enable = true;
            configurationLimit = 15;
            pkiBundle = "/etc/secureboot";
            autoGenerateKeys.enable = true;
            autoEnrollKeys = {
              enable = true;
              autoReboot = true;
            };
          };

          environment = {
            systemPackages = [pkgs.sbctl];
            persist.directories = [boot.lanzaboote.pkiBundle];
          };
        })
      ]);
  };
}
