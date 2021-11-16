{ self, ... } @ inputs:
let
  ## Variable Declaration ##
  # System Architecture
  system = "x86_64-linux";

  # NixOS Version
  version = "21.05";

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
  util = import ./lib { inherit system version lib inputs pkgs; };
  inherit (util) device;
  inherit (util) user;
in
{
  ## Developer Shells ##
  devShell."${system}" = import ./shells { inherit pkgs; };
  devShells."${system}" = import ./shells/custom { inherit pkgs; };

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

  ## User Specific Configuration ##
  homeConfigurations =
  {
    # User V7
    v7 = user.mkHome
    {
      username = "v7";
      roles = [ "dconf" "discord" "firefox" "theme" ];
    };

    # User Navya
    navya = user.mkHome
    {
      username = "navya";
      roles = [ "dconf" "firefox" "theme" ];
    };
  };

  ## Device Specific Configuration ##
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
      kernel_params = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
      init_modules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      modprobe = "options kvm_intel nested=1";
      cores = 8;
      filesystem = "btrfs";
      ssd = true;
      desktop = "gnome";
      roles = [ "android" "ios" "office" "virtualisation" ];
      users =
      [
        {
          username = "v7";
          description = "V 7";
          groups = [ "wheel" "networkmanager" "kvm" "libvirtd" "adbusers" ];
          uid = 1000;
          shell = pkgs.zsh;
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
      filesystem = "ext4";
      desktop = "gnome";
      roles = [ "office" ];
      users =
      [
        {
          username = "navya";
          description = "Navya";
          groups = [ "wheel" "networkmanager" ];
          uid = 1000;
          shell = pkgs.zsh;
        }
      ];
    };
  };
}
