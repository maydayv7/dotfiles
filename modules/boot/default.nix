{ config, lib, pkgs, ... }:
{
  # Boot Configuration
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
      efi =
      {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub =
      {
        efiSupport = true;
        device = "nodev";
        splashImage = null;
        extraConfig = "set timeout_style=hidden";
      };
    };
    
    # Filesystems
    supportedFilesystems = [ "ntfs" ];
  };
}
