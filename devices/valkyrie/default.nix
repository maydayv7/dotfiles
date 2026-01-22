{
  system = "x86_64-linux";
  name = "valkyrie";
  description = "PC - ASUS ROG Zephyrus G14";

  timezone = "Asia/Kolkata";
  locale = "IN";

  kernel = "xanmod";
  kernelModules = [
    "nvme"
    "thunderbolt"
  ];

  imports = [
    ./settings
    ./minecraft.nix
  ];

  hardware = {
    boot = "secure";
    fs.scheme = "advanced";
    modules = [ "asus-zephyrus-ga402x-nvidia" ];
    cpu = {
      model = "amd";
      cores = 8;
      mode = "performance";
    };

    gpu = {
      enable = true;
      model = "nvidia";
    };

    support = [
      "laptop"
      "mobile"
      "printer"
      "virtualisation"
    ];

    vm = {
      android.enable = false;
      vfio = "setup";
      passthrough = [
        "10de:28e0"
        "10de:22be"
      ];
    };
  };

  apps = {
    wine.utilities = true;
    list = [
      "discord"
      "firefox"
      "flatpak"
      "games"
      "git"
      "internet"
      "latex"
      "notes"
      "office"
      "stream"
      "tools"
      "vscode"
      "youtube"
    ];
    games = [
      "minecraft"
      "osu"
      "roblox"
    ];
  };

  shell = {
    prompt = true;
    utilities = true;
  };

  nix = {
    index = true;
    tools = true;
  };

  gui = {
    desktop = "hyprland";
    display = "eDP-1";
    wallpaper = "Quasar";
    fancy = true;
  };

  # User V7
  user = {
    name = "v7";
    description = "V 7";
    uid = 1000;
    shell = "zsh";
    shells = [ "bash" ];
    groups = [
      "wheel"
      "keys"
      "systemd-journal"
      "minecraft"
    ];
  };
}
