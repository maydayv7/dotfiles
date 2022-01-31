{
  system = "x86_64-linux";
  name = "Vortex";
  description = "PC - Dell Inspiron 15 5000";
  channel = "stable";

  timezone = "Asia/Kolkata";
  locale = "en_IN.UTF-8";

  kernel = "linux_lqx";
  kernelModules = [ "nvme" "thunderbolt" ];

  hardware = {
    boot = "efi";
    cores = 8;
    filesystem = "advanced";
    security = true;
    support = [ "mobile" "printer" "ssd" "virtualisation" ];
    modules = [ "dell-inspiron-5509" ];
  };

  desktop = "gnome";
  shell.utilities = true;
  apps = {
    list = [ "discord" "firefox" "git" "office" ];
    git = {
      name = "maydayv7";
      mail = "maydayv7@gmail.com";
    };
  };

  # User V7
  user = {
    name = "v7";
    description = "V 7";
    groups = [ "wheel" "keys" ];
    uid = 1000;
    shell = "zsh";
  };
}