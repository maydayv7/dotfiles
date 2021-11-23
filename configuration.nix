{ self, ... } @ inputs:
let
  ## Variable Declaration ##
  # System Architecture
  system = "x86_64-linux";

  # NixOS Version
  version = (builtins.readFile ./version);

  # Authentication Credentials
  secrets = import ./secrets.nix { inherit inputs; };

  # Dotfiles
  files = import ./files { };

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

  # System Libraries
  inherit (inputs.nixpkgs) lib;
  inherit (lib) attrValues;

  # Custom Functions
  util = import ./lib { inherit system version files secrets lib inputs pkgs; };
  inherit (util) device;
  inherit (util) user;
in
{
  ## Developer Shells ##
  devShell."${system}" = import ./shells/shell.nix { inherit pkgs; };
  devShells."${system}" = import ./shells { inherit pkgs; };

  ## Install Media Configuration ##
  installMedia =
  {
    # Install Media - GNOME
    gnome = device.mkISO
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
    Vortex = device.mkPC
    {
      name = "Vortex";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = pkgs.linuxPackages_lqx;
      kernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

      hardware =
      {
        cores = 8;
        mobile = true;
        filesystem = "advanced";
        ssd = true;
        virtualisation = true;
      };

      desktop = "gnome";
      users =
      [
        # User V7 Configuration
        {
          username = "v7";
          description = "V 7";
          groups = [ "wheel" "networkmanager" "kvm" "libvirtd" "adbusers" ];
          uid = 1000;
          shell = "zsh";
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
        }
      ];
    };

    # PC - Dell Inspiron 11 3000
    Futura = device.mkPC
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
      users =
      [
        # User Navya Configuration
        {
          username = "navya";
          description = "Navya";
          groups = [ "wheel" "networkmanager" ];
          uid = 1000;
          shell = "zsh";
          apps.list = [ "firefox" "office" ];
        }
      ];
    };
  };
}
