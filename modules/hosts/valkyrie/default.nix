# Host: Valkyrie - ASUS ROG Zephyrus G14
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
  inherit (config) util;

  sharedHmModules = [
    homeManager.user
    homeManager.base
    homeManager.filesystem
    homeManager.shell
    homeManager.shell-utils
    homeManager.nix
    homeManager.laptop
    homeManager.virtualisation
    homeManager.theme
    homeManager.gtk
    homeManager.discord
    homeManager.firefox
    homeManager.flatpak
    homeManager.games
    homeManager.osu
    homeManager.minecraft
    homeManager.git
    homeManager.internet
    homeManager.office
    homeManager.latex
    homeManager.notes
    homeManager.spotify
    homeManager.tools
    homeManager.stream
    homeManager.vscode
    homeManager.youtube
    homeManager.wine
  ];
in {
  configurations.nixos.valkyrie = {
    system = "x86_64-linux";
    module = {
      config,
      pkgs,
      ...
    }: {
      imports =
        [
          nixos.base
          nixos.security
          nixos.secrets
          nixos.boot
          nixos.filesystem
          nixos.cpu
          nixos.gpu
          nixos.laptop
          nixos.mobile
          nixos.printer
          nixos.virtualisation
          nixos.vfio
          nixos.android
          nixos.nix
          nixos.shell
          nixos.shell-utils
          nixos.prompt
          nixos.user
          nixos.theme
          nixos.qt
          nixos.gtk
          nixos.fonts
          nixos.flatpak
          nixos.games
          nixos.roblox
          nixos.mc-server
          nixos.git
          nixos.git-runner
          nixos.office
          nixos.latex
          nixos.tools
          nixos.wine

          # Desktop
          nixos.hyprland

          # Device-specific imports
          ./_settings
          ./_minecraft.nix
        ]
        ++ util.map.array ["asus-zephyrus-ga402x-nvidia"] inputs.hardware.nixosModules;

      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "valkyrie");

      # Localization
      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables."LC_ALL" = "en_IN.UTF-8";

      # Kernel
      base = {
        kernel = "xanmod";
        kernelModules = [
          "nvme"
          "thunderbolt"
        ];
      };

      # Hardware
      hardware = {
        boot = "secure";
        fs.scheme = "advanced";
        cpu = {
          model = "amd";
          cores = 8;
          mode = "performance";
        };
        gpu = {
          enable = true;
          model = "nvidia";
        };
        vm = {
          android.enable = false;
          vfio = "setup";
          passthrough = [
            "10de:28e0" # Graphics
            "10de:22be" # Audio
          ];
        };
      };

      # Nix tools
      nix = {
        index = true;
        tools = true;
      };

      # GUI
      gui = {
        display = "eDP-1";
        wallpaper = "Quasar";
        fancy = true;
      };

      # Wine utilities
      apps.wine.utilities = true;

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
          "systemd-journal"
          "minecraft"
          "networkmanager"
          "adbusers"
          "lp"
          "scanner"
          "kvm"
          "libvirtd"
          "i2c"
          "input"
          "video"
        ];
      };

      home-manager.users.v7.imports =
        sharedHmModules
        ++ [
          homeManager.v7
          homeManager.hyprland
          ./_settings/home.nix
        ];
    };
  };

  configurations.homeManager."v7@valkyrie" = {
    module = {
      imports =
        sharedHmModules
        ++ [
          homeManager.v7
          homeManager.hyprland
          ./_settings/home.nix
        ];
      home = {
        username = "v7";
        homeDirectory = "/home/v7";
      };
    };
    system = "x86_64-linux";
  };
}
