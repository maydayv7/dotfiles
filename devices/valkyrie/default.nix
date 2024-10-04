{
  system = "x86_64-linux";
  name = "valkyrie";
  description = "PC - ASUS ROG Zephyrus G14";
  channel = "stable";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "lqx";
  kernelModules = ["nvme" "thunderbolt"];

  imports = [./drivers.nix];
  hardware = {
    boot = "secure";
    filesystem = "advanced";
    support = ["laptop" "mobile" "printer" "virtualisation"];
    modules = ["asus-zephyrus-ga402x-nvidia"];
    vm.android.enable = false;
    cpu = {
      cores = 8;
      mode = "performance";
    };
  };

  shell.utilities = true;
  apps = {
    wine.utilities = true;
    list = [
      "discord"
      "firefox"
      "git"
      "office"
      "spotify"
      "vscode"
    ];
  };

  nix = {
    index = true;
    tools = true;
  };

  gui = {
    desktop = "gnome";
    display = "eDP-1";
    wallpaper = "Nix";
    fancy = true;
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
