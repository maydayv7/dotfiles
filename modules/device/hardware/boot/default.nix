{ config, lib, ... }:
let
  cfg = config.hardware.boot;
in rec
{
  options.hardware.boot = lib.mkOption
  {
    description = "Device Boot Configuration";
    type = lib.types.bool;
    default = "true";
  };

  ## Boot Configuration ##
  config = lib.mkIf (cfg == true)
  {
    boot =
    {
      # Plymouth
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth.enable = true;

      # Boot Loader
      loader =
      {
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
      };
    };
  };
}
