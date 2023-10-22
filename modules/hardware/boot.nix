{
  config,
  options,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce mkIf mkMerge mkOption optional types;
  loader = config.hardware.boot;
in {
  options.hardware.boot = mkOption {
    description = "Supported Boot Firmware";
    type = types.nullOr (types.enum ["mbr" "efi"]);
    default = "mbr";
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
            grub.enable = mkDefault false;
            efi.canTouchEfiVariables = true;
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
          enable = true;
          editor = false;
          configurationLimit = 100;
        };
      })
    ]);
}
