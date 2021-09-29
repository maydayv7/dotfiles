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
      systemd-boot.enable = false;
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
        extraConfig =
        "
        set timeout_style=hidden
        if keystatus ; then
          if keystatus --shift ; then
            set timeout=-1
          else
            set timeout=0
          fi
        else
          set timeout=5
        fi
        ";
      };
    };
    
    # Filesystems
    supportedFilesystems = [ "ntfs" ];
  };
}
