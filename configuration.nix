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

  # Custom Functions
  util = import ./lib { inherit system version files lib inputs pkgs; };
  inherit (util) device iso modules packages user;

  # Program Configuration and Dotfiles
  files = import ./files { };

  # Package Configuration
  unstable = packages.build inputs.unstable [ ];
  pkgs = packages.build inputs.nixpkgs
  [
    inputs.nur.overlay
    (final: prev: { inherit unstable; custom = self.packages."${system}"; })
  ];
in
{
  ## Developer Shells ##
  devShell."${system}" = import ./shells { inherit pkgs; };
  devShells."${system}" = modules.map ./shells (name: import name { inherit pkgs; });

  ## Package Overrides ##
  overrides = modules.map ./packages/overlays import;
  packages."${system}" = modules.map ./packages (name: pkgs.callPackage name { inherit files; });

  ## Custom Configuration Modules ##
  nixosModules = modules.map ./modules import;

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
