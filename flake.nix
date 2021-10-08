{
  description = "My Reproducible, Hermetic, Functional, Portable, Atomic, Multi-PC NixOS Dotfiles";
  
  # Package Repositories
  inputs =
  {
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    
    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Nix Flake Utility Functions
    flake-utils.url = "github:numtide/flake-utils";
    
    # Home Manager
    home-manager =
    {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nix User Repository
    nur.url = "github:nix-community/NUR";
    
    # GNOME Icon Taskbar
    gnome-panel =
    {
      url = "github:maydayv7/gnome-panel";
      flake = false;
    };
  };
  
  outputs = { self, ... } @ inputs:
  let
    # Architecture
    system = "x86_64-linux";
    
    # NixOS Version
    version = "21.05";
    
    # System Libraries
    inherit (inputs.nixpkgs) lib;
    inherit (lib) attrValues;
    
    # Custom Functions
    util = import ./lib { inherit system lib inputs pkgs; };
    inherit (util) shell;
    inherit (util) user;
    inherit (util) host;
    
    # Package Overrides
    inherit (import ./packages { inherit pkgs; }) custom;
    inherit (import ./packages/overlays { inherit system lib inputs pkgs scripts custom; }) overlays;
    
    # Package Configuration
    pkgs = import inputs.nixpkgs
    {
      inherit system;
      config =
      {
        allowUnfree = true;
        allowBroken = true;
      };
      inherit overlays;
    };
    
    # System Scripts
    scripts = import ./scripts { inherit lib pkgs; };
  in
  {
    # User Specific Configuration
    homeManagerConfigurations =
    {
      # Nix Developer Shell
      packages."${system}" = pkgs;
      devShell."${system}" = import ./shell.nix { inherit pkgs; };
      
      shells =
      {
        video = shell.mkShell
        {
          name = "Productivity";
          buildInputs = with pkgs; [ git git-crypt gnupg ];
          script =
          ''
            echo "Productivity"
          '';
        };
      };
      
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
    
    nixosConfigurations =
    {
      # Device Specific Configuration
      Vortex = host.mkHost
      {
        inherit version;
        name = "Vortex";
        kernelPackage = pkgs.linuxPackages_lqx;
        initrdMods = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
        kernelMods = [ "kvm-intel" ];
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
        modprobe = "options kvm_intel nested=1";
        cpuCores = 8;
        modules = [ "android" "fonts" "git" "gnome" "libvirt" "security" "ssd" "xorg" ];
        users =
        [
          {
            name = "v7";
            description = "V 7";
            groups = [ "wheel" "networkmanager" "audio" "video" "cdrom" "disk" "kvm" "libvirtd" "adbusers" ];
            uid = 1000;
            shell = pkgs.zsh;
          }
        ];
      };
      
      Futura = host.mkHost
      {
        inherit version;
        name = "Vortex";
        kernelPackage = pkgs.linuxPackages_5_4;
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        kernelMods = [ ];
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
        modprobe = "";
        cpuCores = 4;
        modules = [ "fonts" "git" "gnome" "security" "xorg" ];
        users =
        [
          {
            name = "navya";
            description = "Navya";
            groups = [ "wheel" "networkmanager" ];
            uid = 1000;
            shell = pkgs.zsh;
          }
        ];
      };
    };
  };
}
