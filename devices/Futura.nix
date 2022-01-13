hardware:
{
  system = "x86_64-linux";
  name = "Futura";
  description = '' PC - Dell Inspiron 11 3000 '';

  timezone = "Asia/Kolkata";
  locale = "en_IN.UTF-8";

  kernel = "linux_5_4";
  kernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

  hardware =
  {
    boot = "efi";
    cores = 4;
    filesystem = "simple";
    modules = with hardware;
    [
      common-cpu-intel
      common-pc
      common-pc-laptop
    ];
  };

  desktop = "gnome";
  apps.list = [ "firefox" "office" ];

  # User Navya
  user =
  {
    name = "navya";
    description = "Navya";
    shell.choice = "zsh";
  };
}
