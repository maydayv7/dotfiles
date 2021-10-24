{
  description = "My Reproducible, Hermetic, Derivational, Portable, Atomic, Multi-PC NixOS Dotfiles";
  
  ## Package Repositories ##
  inputs =
  {
    ## Main Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    
    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager =
    {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nix User Repository
    nur.url = "github:nix-community/NUR";
    
    # Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";
    
    ## Additional Repositories ##
    # User Credentials
    secrets =
    {
      url = "git+ssh://git@github.com/maydayv7/secrets.git";
      flake = false;
    };
    
    # GNOME Icon Taskbar
    gnome-panel =
    {
      url = "github:maydayv7/gnome-panel";
      flake = false;
    };
    
    # Firefox GNOME Theme
    gnome-firefox =
    {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    
    # Z Shell Syntax Highlighting
    zsh-syntax =
    {
      url = "github:zsh-users/zsh-syntax-highlighting?rev=932e29a0c75411cb618f02995b66c0a4a25699bc";
      flake = false;
    };
    
    # Plymouth Boot Logo
    plymouth =
    {
      url = "github:freedesktop/plymouth";
      flake = false;
    };
    
    # Convert Dconf to Nix
    dconf =
    {
      url = "github:gvolpe/dconf2nix";
      flake = false;
    };
  };
  
  ## Output Configuration ##
  outputs = { self, ... } @ inputs:
  let
    ## Variable Declaration ##
    # Architecture
    system = "x86_64-linux";
    
    # NixOS Version
    version = "21.05";
    
    # Package Configuration
    pkgs = import inputs.nixpkgs
    {
      inherit system overlays;
      config =
      {
        allowUnfree = true;
        allowBroken = true;
      };
    };
    
    # Package Overrides
    inherit (import ./packages { inherit inputs pkgs; }) custom;
    inherit (import ./packages/overlays { inherit system lib inputs pkgs scripts custom; }) overlays;
    
    # System Libraries
    inherit (inputs.nixpkgs) lib;
    inherit (lib) attrValues;
    
    # Custom Functions
    util = import ./lib { inherit system lib inputs pkgs; };
    inherit (util) user;
    inherit (util) host;
    
    # System Scripts
    scripts = import ./scripts { inherit lib pkgs; };
  in
  {
    ## Nix Developer Shell ##
    # Run it using nix develop
    legacyPackages."${system}" = (builtins.head (builtins.attrValues self.nixosConfigurations)).pkgs;
    devShell."${system}" = import ./shell.nix { inherit pkgs; };
    
    ## User Specific Configuration ##
    homeManagerConfigurations =
    {
      # User V7
      v7 = user.mkHome
      {
        username = "v7";
        modules = [ "dconf" "discord" "dotfiles" "firefox" "git" "terminal" "theme" "zsh" ];
        inherit version;
      };
      
      # User Navya
      navya = user.mkHome
      {
        username = "navya";
        modules = [ "dconf" "dotfiles" "firefox" "git" "terminal" "theme" "zsh" ];
        inherit version;
      };
    };
    
    ## Device Specific Configuration ##
    nixosConfigurations =
    {
      # PC - Dell Inspiron 15 5000
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
        filesystem = "btrfs";
        ssd = true;
        modules = [ "android" "fonts" "git" "gnome" "libvirt" "office" "security" "xorg" ];
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
            
      # PC - Dell Inspiron 11 3000
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
        filesystem = "ext4";
        ssd = false;
        modules = [ "fonts" "git" "gnome" "office" "security" "xorg" ];
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
