{ config, lib, ... }:
let
  cfg = config.base.enable;
in rec
{
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
