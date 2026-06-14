# Futura - Dell Inspiron 11 3000
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos homeManager;
  inherit (config) util;

  sharedHmModules =
    util.map.array [
      "filesystem"
      "laptop"
      "firefox"
      "office"
    ]
    homeManager;
in {
  configurations.nixos.futura = {
    system = "x86_64-linux";
    module = {pkgs, ...}: {
      imports =
        util.map.array [
          "boot"
          "security"
          "filesystem"
          "laptop"
          "office"
          "flatpak"
          "gnome"
        ]
        nixos
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

      system = {
        kernel = "lts";
        scheme = "efi";
        fs.scheme = "simple";
      };

      hardware.cpu = {
        model = "intel";
        cores = 4;
      };

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
          homeManager.gnome
        ];

      services.displayManager.autoLogin = {
        enable = true;
        user = "navya";
      };
    };
  };

  configurations.homeManager."navya@futura" = {
    module = {
      imports =
        sharedHmModules
        ++ [
          homeManager.navya
          homeManager.gnome
        ];
      home = {
        username = "navya";
        homeDirectory = "/home/navya";
      };
    };
    system = "x86_64-linux";
  };
}
