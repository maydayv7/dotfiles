{ ... }:
rec
{
  ## Boot Configuration ##
  config =
  {
    boot =
    {
      cleanTmpDir = true;

      # Plymouth
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth.enable = true;
      kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];

      # Boot Loader
      loader =
      {
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot =
        {
          enable = true;
          configurationLimit = 100;
        };
      };
    };
  };
}
