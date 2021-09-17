{ config, lib, pkgs, ... }:
{
  boot =
  {
    # Kernel
    initrd.availableKernelModules = [ "xhci_pci" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ "i915" ];
    
    # Plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    
    # Silent Boot
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
    
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
