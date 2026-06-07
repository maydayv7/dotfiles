# Host: Valkyrie - ASUS ROG Zephyrus G14
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;

  # Shared home-manager modules for all users on this host
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
    homeManager.discord
    homeManager.firefox
    homeManager.flatpak
    homeManager.games
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
in
{
  configurations.nixos.valkyrie.module = { pkgs, ... }: {
    imports = [
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
      nixos.fonts
      nixos.discord
      nixos.firefox
      nixos.flatpak
      nixos.games
      nixos.git
      nixos.git-runner
      nixos.internet
      nixos.office
      nixos.latex
      nixos.notes
      nixos.spotify
      nixos.tools
      nixos.stream
      nixos.vscode
      nixos.wine
      nixos.youtube
      # Desktop
      nixos.hyprland
      # Device-specific imports
      ./_valkyrie/settings
      ./_valkyrie/minecraft.nix
    ]
    ++ config.util.map.array
      [ "asus-zephyrus-ga402x-nvidia" ]
      inputs.hardware.nixosModules;

    nixpkgs.hostPlatform = "x86_64-linux";
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
      desktop = "hyprland";
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
      ];
    };

    home-manager.users.v7.imports = sharedHmModules ++ [
      homeManager.v7
      homeManager.hyprland
    ];

    # System version
    system.stateVersion = "25.11";
  };

  # Standalone home-manager configuration
  configurations.homeManager."v7@valkyrie" = {
    module = {
      imports = sharedHmModules ++ [
        homeManager.v7
        homeManager.hyprland
      ];
      home = {
        username = "v7";
        homeDirectory = "/home/v7";
        stateVersion = "25.11";
      };
    };
    system = "x86_64-linux";
  };
}
