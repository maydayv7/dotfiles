{
  description = "My Reproducible, Hermetic, Derivational, Portable, Atomic, Multi-PC NixOS Dotfiles";

  ## Package Repositories ##
  inputs =
  {
    ## Main Repositories ##
    # NixOS Stable Release
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-21.05";

    # Unstable Packages Repository
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Home Manager
    home-manager =
    {
      url = "github:nix-community/home-manager?ref=release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Persistent State Handler
    impermanence.url = "github:nix-community/impermanence";

    ## Additional Repositories ##
    # Personal Credentials
    secrets =
    {
      url = "github:maydayv7/secrets";
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
      url = "github:zsh-users/zsh-syntax-highlighting";
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
    inherit (import ./packages/overlays { inherit system lib inputs pkgs custom; }) overlays;

    # System Libraries
    inherit (inputs.nixpkgs) lib;
    inherit (lib) attrValues;

    # Custom Functions
    util = import ./lib { inherit system version lib inputs pkgs; };
    inherit (util) user;
    inherit (util) device;
  in
  {
    ## Nix Developer Shell ##
    # Run it using nix develop
    devShell."${system}" = import ./shell.nix { inherit pkgs; };

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
        kernelMods = [ "kvm-intel" ];
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
        initrdMods = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
        modprobe = "options kvm_intel nested=1";
        cores = 8;
        filesystem = "btrfs";
        ssd = true;
        desktop = "gnome";
        roles = [ "android" "office" "virtualisation" ];
        users =
        [
          {
            name = "v7";
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
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
        initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
        cores = 4;
        filesystem = "ext4";
        desktop = "gnome";
        roles = [ "office" ];
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
