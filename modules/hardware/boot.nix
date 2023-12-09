{
  config,
  options,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkForce mkIf mkMerge mkOption optional types;
  loader = config.hardware.boot;
in {
  imports = [inputs.boot.nixosModules.lanzaboote];

  options.hardware.boot = mkOption {
    description = "Supported Boot Firmware";
    type = types.nullOr (types.enum ["mbr" "efi" "secure"]);
    default = "efi";
  };

  ## Boot Configuration ##
  config =
    {
      warnings =
        optional (loader == null)
        (options.hardware.boot.description + " is unset");
    }
    // mkIf (loader != null) (mkMerge [
      {
        boot = {
          tmp = rec {
            useTmpfs = true;
            cleanOnBoot = !useTmpfs;
          };

          # Plymouth
          consoleLogLevel = 0;
          initrd.verbose = false;
          plymouth.enable = true;
          kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "i915.fastboot=1"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
          ];

          # Boot Loader
          loader = {
            timeout = mkDefault 0;
            efi.canTouchEfiVariables = true;

            grub.enable = mkDefault false;
            systemd-boot.enable = mkDefault false;
          };
        };

        # Debug
        specialisation.recovery.configuration = {
          boot = {
            initrd.verbose = mkForce true;
            plymouth.enable = mkForce false;
          };
        };
      }

      ## GRUB MBR Boot Loader ##
      (mkIf (loader == "mbr") {
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

      ## SystemD EFI Boot Loader ##
      (mkIf (loader == "efi") {
        boot.loader.systemd-boot = {
          enable = mkForce true;
          editor = false;
          configurationLimit = 15;
        };
      })

      ## Secure Boot (EFI Only) ##
      (mkIf (loader == "secure") rec {
        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
          configurationLimit = 15;
        };

        environment = {
          systemPackages = [pkgs.sbctl];
          persist.directories = [boot.lanzaboote.pkiBundle];
        };
      })
    ]);
}
