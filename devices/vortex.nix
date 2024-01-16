{
  system = "x86_64-linux";
  name = "vortex";
  description = "PC - Dell Inspiron 15 5000";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "xanmod";
  kernelModules = ["nvme" "thunderbolt"];

  hardware = {
    boot = "secure";
    cores = 8;
    filesystem = "advanced";
    support = ["laptop" "mobile" "printer" "virtualisation"];
    modules = ["dell-inspiron-5509"];
    vm.android.enable = false;
  };

  shell.utilities = true;
  apps = {
    list = ["discord" "firefox" "git" "office" "vscode" "wine"];
    wine.utilities = true;
  };

  nix = {
    index = true;
    tools = true;
  };

  gui = {
    desktop = "xfce";
    wallpaper = "Sunset";
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
