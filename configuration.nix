{ self, ... } @ inputs:
let
  ## Variable Declaration ##
  # System Architecture
  system = "x86_64-linux";

  # NixOS Version
  version = (builtins.readFile ./version);

  # Authentication Credentials
  secrets = import ./secrets { inherit inputs; };

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
  inherit (import ./packages { inherit inputs pkgs; }) custom;
  inherit (import ./overlays { inherit system lib inputs pkgs custom; }) overlays;

  # System Libraries
  inherit (inputs.nixpkgs) lib;
  inherit (lib) attrValues;

  # Custom Functions
  util = import ./lib { inherit system version secrets lib inputs pkgs; };
  inherit (util) device;
  inherit (util) user;
in
{
  ## Developer Shells ##
  devShell."${system}" = import ./shells/default { inherit pkgs; };
  devShells."${system}" = import ./shells { inherit pkgs; };

  ## Install Media Configuration ##
  installMedia =
  {
    # GNOME Install Media
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
    Vortex = device.mkHost
    {
      name = "Vortex";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = pkgs.linuxPackages_lqx;
      kernel_modules = [ "kvm-intel" ];
      kernel_params = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];
      init_modules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      modprobe = "options kvm_intel nested=1";
      cores = 8;
      filesystem = "advanced";
      ssd = true;
      desktop = "gnome";
      roles = [ "android" "ios" "office" "virtualisation" ];
      users =
      [
        # User V7 Configuration
        {
          username = "v7";
          description = "V 7";
          groups = [ "wheel" "networkmanager" "kvm" "libvirtd" "adbusers" ];
          uid = 1000;
          shell = pkgs.zsh;
          roles = [ "dconf" "discord" "firefox" "theme" ];
        }
      ];
    };

    # PC - Dell Inspiron 11 3000
    Futura = device.mkHost
    {
      name = "Futura";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = pkgs.linuxPackages_5_4;
      kernel_params = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
      init_modules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      cores = 4;
      filesystem = "simple";
      desktop = "gnome";
      roles = [ "office" ];
      users =
      [
        # User Navya Configuration
        {
          username = "navya";
          description = "Navya";
          groups = [ "wheel" "networkmanager" ];
          uid = 1000;
          shell = pkgs.zsh;
          roles = [ "dconf" "firefox" "theme" ];
        }
      ];
    };
  };
}
