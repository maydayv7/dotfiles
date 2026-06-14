# Vortex - Dell Inspiron 15 5000
{
  config,
  inputs,
  ...
}: let
  inherit (config) util;
  inherit (config.flake.modules) nixos homeManager;

  hmModules =
    util.map.array [
      "shell-utils"
      "filesystem"
      "laptop"
      "discord"
      "firefox"
      "internet"
      "office"
      "wine"
      "hyprland"
    ]
    homeManager;
in {
  configurations.nixos.vortex = {
    system = "x86_64-linux";
    module = {
      config,
      pkgs,
      ...
    }: {
      imports =
        util.map.array
        [
          "security"
          "boot"
          "filesystem"
          "laptop"
          "mobile"
          "printer"
          "libvirt"
          "shell-utils"
          "prompt"
          "office"
          "wine"
          "hyprland"
        ]
        nixos
        ++ util.map.array ["dell-inspiron-5509"] inputs.hardware.nixosModules;

      networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" "vortex");

      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_IN";
      environment.variables."LC_ALL" = "en_IN.UTF-8";

      services.fwupd.enable = true;

      system = {
        scheme = "secure";
        fs.scheme = "advanced";
        kernel = "xanmod";
        kernelModules = [
          "nvme"
          "thunderbolt"
        ];

        nix = {
          index = true;
          tools = true;
        };
      };

      hardware.cpu = {
        model = "intel";
        cores = 8;
      };

      gui = {
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
        extraGroups = [
          "wheel"
          "keys"
          "networkmanager"
          "adbusers"
          "lp"
          "scanner"
          "kvm"
          "libvirtd"
          "input"
          "video"
        ];
      };

      home-manager.users.v7.imports = hmModules ++ [homeManager.v7];
    };
  };

  configurations.homeManager."v7@vortex" = {
    module = {
      imports = hmModules ++ [homeManager.v7];
      home = {
        username = "v7";
        homeDirectory = "/home/v7";
      };
    };
    system = "x86_64-linux";
  };
}
