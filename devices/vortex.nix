{
  system = "x86_64-linux";
  name = "vortex";
  description = "PC - Dell Inspiron 15 5000";
  channel = "stable";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "xanmod";
  kernelModules = ["nvme" "thunderbolt"];

  imports = [{services.fwupd.enable = true;}];
  hardware = {
    boot = "secure";
    filesystem = "advanced";
    support = ["laptop" "mobile" "printer" "virtualisation"];
    modules = ["dell-inspiron-5509"];
    vm.android.enable = true;
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
      "vscode"
      "wine"
    ];
  };

  nix = {
    index = true;
    tools = true;
  };

  gui = {
    desktop = "gnome";
    display = "eDP-1";
    wallpaper = "Thread";
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
