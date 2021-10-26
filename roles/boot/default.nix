{ lib, ... }:
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
      systemd-boot.enable = true;
      efi =
      {
        canTouchEfiVariables = true;
      };
    };
    
    # Filesystems
    supportedFilesystems = [ "ntfs" "btrfs" ];
  };
}
