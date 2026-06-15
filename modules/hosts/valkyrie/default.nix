# Valkyrie - ASUS ROG Zephyrus G14
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
  inherit (config) util;

  nixosModules = [
    "base-ext"
    "boot"
    "security"
    "prompt"
    "mobile"
    "printer"
    "docker"
    #"mc-server"
    #"roblox"
  ];

  hmModules = [
    "auth"
    "discord"
    "firefox"
    "internet"
    "notes"
    "spotify"
    "stream"
    "syncthing"
    "vscode"
    "minecraft"
    "osu"
  ];

  mixedModules = [
    "filesystem"
    "laptop"
    "mouse"
    "shell-utils"
    "git"
    "office"
    "tools"
    #"flatpak"
    "latex"
    #"wine"
    "games"
    "gnome"
  ];

  hmImports =
    util.map.array hmModules homeManager
    ++ util.map.array mixedModules homeManager;

  settings = import ./_settings {};
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
        ++ [
          (settings.nixos or {})
          # ./_minecraft.nix
        ]
        ++ util.map.array ["asus-zephyrus-ga402x-nvidia"] inputs.hardware.nixosModules;

      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "valkyrie");

      # Localization
      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables."LC_ALL" = "en_IN.UTF-8";

      system = {
        scheme = "secure";
        fs.scheme = "advanced";

        # Kernel
        kernel = "xanmod";
        kernelModules = [
          "nvme"
          "thunderbolt"
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
        wallpaper = "Bluewatch";
        fancy = true;
      };

      # Virtualisation
      # virt.vfio = {
      #   setup = true;
      #   passthrough = [
      #     "10de:28e0" # Graphics
      #     "10de:22be" # Audio
      #   ];
      # };

      # Wine utilities
      # apps.wine.utilities = true;

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
          #"kvm"
          #"libvirtd"
        ];
      };

      home-manager.users.v7.imports =
        hmImports
        ++ [
          homeManager.v7
          (settings.home or {})
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
