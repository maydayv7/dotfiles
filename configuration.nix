{ self, ... } @ inputs:
let
  ## Variable Declaration ##
  # System Architecture
  system = "x86_64-linux";

  # NixOS Version
  version = (builtins.readFile ./version);

  # System Libraries
  inherit (inputs.nixpkgs) lib;
  inherit (lib) attrValues;

  # Package Configuration
  pkgs = import inputs.nixpkgs
  {
    inherit system overlays;
    config =
    {
      allowAliases = true;
      allowUnfree = true;
      allowBroken = true;
    };
  };

  # Package Overrides
  inherit (import ./packages { inherit files inputs pkgs; }) custom;
  inherit (import ./packages/overlays { inherit system lib inputs pkgs custom; }) overlays;

  # Program Configuration and Dotfiles
  files = import ./files { };

  # Custom Functions
  util = import ./lib { inherit system version files lib inputs pkgs; };
  inherit (util) device iso user;
in
{
  ## Developer Shells ##
  devShell."${system}" = import ./shells/shell.nix { inherit pkgs; };
  devShells."${system}" = import ./shells { inherit pkgs; };

  ## Custom Configuration Modules ##
  nixosModules =
  {
    apps = import ./modules/apps;
    base = import ./modules/base;
    gui = import ./modules/gui;
    hardware = import ./modules/hardware;
    iso = import ./modules/iso;
    nix = import ./modules/nix;
    scripts = import ./scripts;
    secrets = import ./secrets;
    shell = import ./modules/shell;
    user = import ./modules/user;
  };

  ## Install Media Configuration ##
  installMedia =
  {
    # Install Media - GNOME
    gnome = iso.build
    {
      name = "nixos";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = pkgs.linuxPackages_latest;
      desktop = "gnome";
    };
  };

  ## Device Configuration ##
  nixosConfigurations =
  {
    # PC - Dell Inspiron 15 5000
    Vortex = device.build
    {
      name = "Vortex";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = pkgs.linuxPackages_lqx;
      kernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

      hardware =
      {
        cores = 8;
        filesystem = "advanced";
        support = [ "mobile" "printer" "ssd" "virtualisation" ];
      };

      desktop = "gnome";
      apps =
      {
        list = [ "discord" "firefox" "git" "office" ];
        git =
        {
          name = "maydayv7";
          mail = "maydayv7@gmail.com";
          key = "CF616EB19C2765E4";
        };
      };

      users =
      [
        # User V7 Configuration
        {
          username = "v7";
          description = "V 7";
          groups = [ "wheel" "networkmanager" "kvm" "libvirtd" "adbusers" "scanner" ];
          uid = 1000;
          shell = "zsh";
        }
      ];
    };

    # PC - Dell Inspiron 11 3000
    Futura = device.build
    {
      name = "Futura";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = pkgs.linuxPackages_5_4;
      kernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

      hardware =
      {
        cores = 4;
        filesystem = "simple";
      };

      desktop = "gnome";
      apps.list = [ "firefox" "office" ];

      users =
      [
        # User Navya Configuration
        {
          username = "navya";
          description = "Navya";
          groups = [ "wheel" "networkmanager" ];
          uid = 1000;
          shell = "zsh";
        }
      ];
    };
  };
}
