{
  system = "x86_64-linux";
  name = "valkyrie";
  description = "PC - ASUS ROG Zephyrus G14";
  channel = "stable";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "xanmod";
  kernelModules = ["nvme" "thunderbolt"];

  imports = [./drivers.nix];
  hardware = {
    boot = "secure";
    filesystem = "advanced";
    support = ["laptop" "mobile" "printer" "virtualisation"];
    modules = ["asus-zephyrus-ga402x-nvidia"];
    cpu = {
      cores = 8;
      mode = "performance";
    };

    vm = {
      vfio = "on";
      android.enable = true;
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
    desktop = "hyprland";
    display = "eDP-1";
    wallpaper = "Thread";
    fancy = true;
  };

  # User V7
  user = {
    name = "v7";
    description = "V 7";
    groups = ["wheel" "keys" "systemd-journal"];
    uid = 1000;
    shell = "zsh";
    shells = ["bash"];
  };
}
