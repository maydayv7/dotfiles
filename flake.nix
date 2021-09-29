{
  description = "My NixOS Config";
  
  # Package Repositories
  inputs =
  {
    # NixOS Stable Release
    nixpkgs.url = "nixpkgs/nixos-21.05";
    
    # Unstable Packages
    unstable.url = "nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager =
    {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, unstable, home-manager }:
  let
    # Architecture
    system = "x86_64-linux";
    
    # NixOS Version
    version = "21.05";
    
    # Root Password
    password = "/etc/passwords/root";
    
    # Package Configuration
    pkgs = import nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
    };
    
    # System Libraries
    inherit (nixpkgs) lib;
    inherit (lib) attrValues;
    
    # Custom Functions
    util = import ./lib { inherit system pkgs home-manager lib; };
    inherit (util) host;
    inherit (util) user;
  in
  {    
    nixosConfigurations =
    {
      # Device Specific Configuration
      Vortex = host.mkHost
      {
        inherit version;
        inherit password;
        name = "Vortex";
        kernelPackage = pkgs.linuxPackages_lqx;
        initrdMods = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
        kernelMods = [ "kvm-intel" ];
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
        modprobe = "options kvm_intel nested=1";
        cpuCores = 8;
        modules = [ "boot" "core" "fonts" "git" "gnome" "hardware" "libvirt" "networking" "packages" "security" "services" "ssd" "xorg" ];
        users =
        [
          {
            name = "v7";
            description = "V 7";
            groups = [ "wheel" "networkmanager" "audio" "video" "cdrom" "disk" "kvm" "libvirtd" ];
            uid = 1000;
            shell = pkgs.zsh;
            passwordFile = "/etc/passwords/v7";
          }
        ];
      };
      
      Futura = host.mkHost
      {
        inherit version;
        inherit password;
        name = "Vortex";
        kernelPackage = pkgs.linuxPackages_lqx;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ ];
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
        modprobe = "";
        cpuCores = 4;
        modules = [ "boot" "core" "fonts" "git" "gnome" "hardware" "networking" "packages" "security" "services" "xorg" ];
        users =
        [
          {
            name = "navya";
            description = "Navya";
            groups = [ "wheel" "networkmanager" ];
            uid = 1000;
            shell = pkgs.zsh;
            passwordFile = "/etc/passwords/navya";
          }
        ];
      };
    };
    
    # User Specific Configuration
    homeManagerConfigurations =
    {
      v7 = user.mkHome
      {
        username = "v7";
        modules = [ "dconf" "discord" "dotfiles" "firefox" "git" "terminal" "theme" "zsh" ];
        inherit version;
      };
      
      navya = user.mkHome
      {
        username = "navya";
        modules = [ "dconf" "dotfiles" "firefox" "git" "terminal" "theme" "zsh" ];
        inherit version;
      };
    };
  };
}
