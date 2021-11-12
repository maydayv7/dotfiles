{ config, lib, ... }:
let
  device = config.device.enable;
in rec
{
  ## Boot Configuration ##
  config = lib.mkIf device
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
