hardware: {
  system = "x86_64-linux";
  name = "Vortex";
  description = "PC - Dell Inspiron 15 5000 ";
  repo = "stable";

  timezone = "Asia/Kolkata";
  locale = "en_IN.UTF-8";

  kernel = "linux_lqx";
  kernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

  hardware = {
    boot = "efi";
    cores = 8;
    filesystem = "advanced";
    support = [ "mobile" "printer" "ssd" "virtualisation" ];
    modules = [ hardware.dell-inspiron-5509 ];
  };

  desktop = "gnome";
  apps = {
    list = [ "discord" "firefox" "git" "office" "wine" ];
    git = {
      name = "maydayv7";
      mail = "maydayv7@gmail.com";
      runner = true;
    };
  };

  # User V7
  user = {
    name = "v7";
    description = "V 7";
    groups = [ "wheel" "keys" ];
    uid = 1000;
    shell = {
      choice = "zsh";
      utilities = true;
    };
  };
}
