{ self, ... } @ inputs:
let
  ## Variable Declaration ##
  # System Architecture
  system = "x86_64-linux";

  # NixOS Version
  version = (builtins.readFile ./version);

  # System Libraries
  inherit (inputs.nixpkgs) lib;

  # Custom Functions
  util = import ./lib { inherit system version files lib inputs pkgs; };
  inherit (util) build map;

  # Package Configuration
  unstable = map.packages inputs.unstable [ ];
  pkgs = map.packages inputs.nixpkgs [ self.overlay inputs.nur.overlay ];

  # Dotfiles and Program Configuration
  files = import ./files { };
in
{
  ## Developer Shells ##
  # Default Developer Shell
  devShell."${system}" = import ./shells { inherit pkgs; };

  # Tailored Developer Shells
  devShells."${system}" = map.modules ./shells (name: import name { inherit pkgs; });

  ## Package Configuration ##
  # Overrides
  overlay = final: prev: { inherit unstable; custom = self.packages."${system}"; };
  overlays = map.modules ./packages/overlays import;

  # Custom Packages
  packages."${system}" = map.modules ./packages (name: pkgs.callPackage name { inherit files; });

  ## Custom Configuration Modules ##
  nixosModules = map.modules ./modules import;

  ## Install Media Configuration ##
  installMedia =
  {
    # Install Media - GNOME
    gnome = build.iso
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
    Vortex = build.device
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
          groups = [ "wheel" ];
          uid = 1000;
          shell = "zsh";
        }
      ];
    };

    # PC - Dell Inspiron 11 3000
    Futura = build.device
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
          shell = "zsh";
        }
      ];
    };
  };
}
