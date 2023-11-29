{
  system = "x86_64-linux";
  name = "Vortex";
  description = "PC - Dell Inspiron 15 5000";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "lqx";
  kernelModules = ["nvme" "thunderbolt"];

  imports = [./secrets];

  hardware = {
    boot = "efi";
    cores = 8;
    filesystem = "advanced";
    security = true;
    support = ["laptop" "mobile" "printer" "virtualisation"];
    modules = ["dell-inspiron-5509"];
    vm.android.enable = true;
  };

  gui = {
    desktop = "gnome";
    wallpaper = "Nix";
  };

  nix = {
    index = true;
    tools = true;
  };

  shell.utilities = true;
  apps = {
    list = ["discord" "firefox" "git" "office" "vscode" "wine"];
    wine.utilities = true;
  };

  # User V7
  user = {
    name = "v7";
    description = "V 7";
    groups = ["wheel" "keys"];
    uid = 1000;
    shell = "zsh";
    shells = ["bash"];
  };
}
