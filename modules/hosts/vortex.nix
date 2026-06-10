# Host: Vortex - Dell Inspiron 15 5000
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
    homeManager.theme
    homeManager.discord
    homeManager.firefox
    homeManager.internet
    homeManager.office
    homeManager.wine
  ];
in {
  configurations.nixos.vortex = {
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
          nixos.laptop
          nixos.mobile
          nixos.printer
          nixos.virtualisation
          nixos.nix
          nixos.shell
          nixos.shell-utils
          nixos.prompt
          nixos.user
          nixos.theme
          nixos.qt
          nixos.gtk
          nixos.fonts
          nixos.discord
          nixos.firefox
          nixos.internet
          nixos.office
          nixos.wine
          nixos.hyprland
        ]
        ++ util.map.array ["dell-inspiron-5509"] inputs.hardware.nixosModules;

      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "vortex");

      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables."LC_ALL" = "en_IN.UTF-8";

      services.fwupd.enable = true;

      base = {
        kernel = "xanmod";
        kernelModules = [
          "nvme"
          "thunderbolt"
        ];
      };

      hardware = {
        boot = "secure";
        fs.scheme = "advanced";
        cpu = {
          model = "intel";
          cores = 8;
        };
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

      apps.wine.utilities = true;

      users.users.v7 = {
        isNormalUser = true;
        description = "V 7";
        uid = 1000;
        group = "users";
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets."v7.secret".path;
        extraGroups =
          [
            "wheel"
            "keys"
            "networkmanager"
            "adbusers"
            "lp"
            "scanner"
            "kvm"
            "libvirtd"
          ]
          ++ config.user.groups;
      };

      home-manager.users.v7.imports =
        sharedHmModules
        ++ [
          homeManager.v7
          homeManager.hyprland
        ];
    };
  };

  configurations.homeManager."v7@vortex" = {
    module = {
      imports =
        sharedHmModules
        ++ [
          homeManager.v7
          homeManager.hyprland
        ];
      home = {
        username = "v7";
        homeDirectory = "/home/v7";
      };
    };
    system = "x86_64-linux";
  };
}
