{
  system = "x86_64-linux";
  name = "Vortex";
  description = "PC - Dell Inspiron 15 5000";
  channel = "stable";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "lqx";
  kernelModules = ["nvme" "thunderbolt"];

  hardware = {
    boot = "efi";
    cores = 8;
    filesystem = "advanced";
    security = true;
    support = ["mobile" "printer" "virtualisation"];
    modules = ["dell-inspiron-5509"];
  };

  gui.desktop = "gnome";
  shell.utilities = true;
  apps.list = ["discord" "firefox" "flatpak" "git" "office" "vscode" "wine"];

  # User V7
  user = {
    name = "v7";
    description = "V 7";
    groups = ["wheel" "keys"];
    uid = 1000;
    shell = "zsh";
    shells = ["bash"];
    recovery = true;
  };
}
