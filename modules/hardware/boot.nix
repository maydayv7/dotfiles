{ config, lib, ... }:
let inherit (config.hardware) boot;
in rec {
  options.hardware.boot = lib.mkOption {
    description = "Supported Boot Firmware";
    type = lib.types.enum [ "mbr" "efi" ];
    default = "mbr";
  };

  ## Boot Configuration ##
  config = lib.mkIf (boot == "efi") {
    boot = {
      tmpOnTmpfs = true;

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
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          editor = true;
          configurationLimit = 100;
        };
      };
    };
  };
}
