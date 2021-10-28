{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  config = mkIf (cfg == true)
  {
    ## Boot Configuration ##
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
      
      # Filesystems
      supportedFilesystems = [ "ntfs" "btrfs" ];
    };
  };
}
