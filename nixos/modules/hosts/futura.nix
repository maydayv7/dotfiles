# Host: Futura - Dell Inspiron 11 3000
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
    homeManager.nix
    homeManager.laptop
    homeManager.theme
    homeManager.firefox
    homeManager.office
  ];
in {
  configurations.nixos.futura = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports =
        [
          nixos.base
          nixos.security
          nixos.secrets
          nixos.boot
          nixos.filesystem
          nixos.cpu
          nixos.laptop
          nixos.nix
          nixos.shell
          nixos.user
          nixos.theme
          nixos.qt
          nixos.gtk
          nixos.fonts
          nixos.firefox
          nixos.office
          nixos.pantheon
          nixos.flatpak
        ]
        ++ util.map.array [
          "common-pc"
          "common-pc-laptop"
          "common-cpu-intel"
        ]
        inputs.hardware.nixosModules;

      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "futura");

      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables."LC_ALL" = "en_IN.UTF-8";

      base.kernel = "lts";

      hardware = {
        boot = "efi";
        fs.scheme = "simple";
        cpu = {
          model = "intel";
          cores = 4;
        };
      };

      gui.desktop = "pantheon";

      # Auto-upgrade
      system.autoUpgrade = {
        enable = true;
        dates = "weekly";
        flake = "github:maydayv7/dotfiles";
      };

      users.users.navya = {
        isNormalUser = true;
        description = "Navya";
        uid = 1000;
        group = "users";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        initialHashedPassword = "";
      };

      home-manager.users.navya.imports =
        sharedHmModules
        ++ [
          homeManager.navya
          homeManager.pantheon
        ];

      # Auto-login for this minimal system
      services.displayManager.autoLogin = {
        enable = true;
        user = "navya";
      };

      system.stateVersion = "25.11";
    };
  };

  configurations.homeManager."navya@futura" = {
    module = {
      imports =
        sharedHmModules
        ++ [
          homeManager.navya
          homeManager.pantheon
        ];
      home = {
        username = "navya";
        homeDirectory = "/home/navya";
        stateVersion = "25.11";
      };
    };
    system = "x86_64-linux";
  };
}
