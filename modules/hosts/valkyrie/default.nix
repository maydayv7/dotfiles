# Valkyrie - ASUS ROG Zephyrus G14
{
  config,
  inputs,
  ...
} @ args: let
  inherit (config.flake.modules) nixos homeManager;
  inherit (config) util;

  nixosModules = [
    "boot"
    "prompt"
    "mobile"
    "printer"
    "docker"
    "mc-server"
    #"roblox"
    #"vfio"
  ];

  hmModules = [
    "secrets"
    "auth"
    #"syncthing"
    "internet"
    "firefox"
    "notes"
    "discord"
    "spotify"
    "vscode"
    "antigravity"
    "zed"
    "codex"
    #"stream"
    "minecraft"
    #"osu"
  ];

  mixedModules = [
    "base-ext"
    "filesystem"
    "security"
    "laptop"
    "mouse"
    "shell-utils"
    "git"
    "office"
    "tools"
    #"flatpak"
    #"latex"
    #"wine"
    #"games"
    #"libvirt"
    "hyprland"
  ];

  hmImports =
    util.map.array hmModules homeManager
    ++ util.map.array mixedModules homeManager;

  disk = import ./_disk/dualboot.nix args;
  asus = import ./_asus {};
  dev = import ./_dev.nix {};
  #vm = import ./_vm args;
in {
  configurations.nixos.valkyrie = {
    system = "x86_64-linux";
    module = {
      config,
      pkgs,
      ...
    }: {
      imports =
        util.map.array nixosModules nixos
        ++ util.map.array mixedModules nixos
        ++ [disk.nixos (asus.nixos or {}) (dev.nixos or {})]
        ++ util.map.array ["asus-zephyrus-ga402x-nvidia"] inputs.hardware.nixosModules;

      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "valkyrie");

      # Localization
      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables."LC_ALL" = "en_IN.UTF-8";

      system = {
        scheme = "secure";

        # Kernel
        kernel = "zen";
        kernelModules = [
          "nvme"
          "thunderbolt"
          "asus-armoury"
        ];

        # Nix Tools
        nix = {
          index = true;
          tools = true;
        };
      };

      # Hardware
      hardware = {
        cpu = {
          model = "amd";
          cores = 8;
          mode = "performance";
        };
        gpu = {
          enable = true;
          model = "nvidia";
        };
      };

      # GUI
      gui = {
        display = "eDP-1";
        wallpaper = "Quasar";
        fancy = true;
      };

      # Virtualisation
      # virt.vfio = {
      #   setup = true;
      #   passthrough = [
      #     "10de:28e0" # Graphics
      #     "10de:22be" # Audio
      #   ];
      #   isolate = "2-4,10-12";
      #   hugepages = 16;
      # };

      # Minecraft Server
      games.mc-servers = [
        {
          type = "fabric";
          memory = 16;
          port = 25565;
          vc-port = 24454;
          config = {
            gamemode = "survival";
            difficulty = "normal";
            online-mode = false;
            server-ip = "0.0.0.0";
            spawn-protection = 0;
            motd = "My World";
          };
        }
      ];

      # User V7
      users.users.v7 = {
        isNormalUser = true;
        description = "V 7";
        uid = 1000;
        group = "users";
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets."v7.secret".path;
        extraGroups = [
          "wheel"
          "keys"
          "adbusers"
          "docker"
          "i2c"
          "input"
          "lp"
          "networkmanager"
          "scanner"
          "systemd-journal"
          "video"
          "minecraft"
          "kvm"
          "libvirtd"
        ];
      };

      home-manager.users.v7.imports =
        hmImports
        ++ [
          homeManager.v7
          (asus.home or {})
          (dev.home or {})
        ];
    };
  };

  configurations.homeManager."v7@valkyrie" = {
    module = {
      imports = hmImports ++ [homeManager.v7];
      home = {
        username = "v7";
        homeDirectory = "/home/v7";
      };
    };
    system = "x86_64-linux";
  };
}
