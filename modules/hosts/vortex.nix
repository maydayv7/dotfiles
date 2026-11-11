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
      "secrets"
      "shell-utils"
      "laptop"
      "security"
      "discord"
      "firefox"
      "brave"
      "thunderbird"
      "teams"
      "whatsapp"
      "zoom"
      "office"
      "calibre"
      "libreoffice"
      "onlyoffice"
      "pdf"
      "gimp"
      "handbrake"
      "inkscape"
      "wine"
      "niri"
    ]
    homeManager;
in {
  configurations.nixos.vortex = {
    system = "x86_64-linux";
    module = _: {
      imports =
        util.map.array
        [
          "v7"
          "security"
          "laptop"
          "mobile"
          "printer"
          "libvirt"
          "shell-utils"
          "prompt"
          "office"
          "wine"
          "niri"
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
        fs = {
          scheme = "advanced";
          disk = "/dev/disk/by-id/disko-placeholder";
        };

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

      # User
      users.users.v7.extraGroups = [
        "wheel"
        "networkmanager"
        "adbusers"
        "lp"
        "scanner"
      ];

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
