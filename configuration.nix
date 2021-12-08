{ self, ... } @ inputs:
let
  ## Variable Declaration ##
  # Supported system Architectures
  systems = [ "x86_64-linux" ];

  # NixOS Version
  version = import ./version.nix;

  # System Libraries
  inherit (builtins) head attrValues;
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.utils.lib) eachSystem;

  # Custom Functions
  util = import ./lib { inherit systems version lib util inputs channels path files; };
  inherit (util) build map;

  # Package Channels
  channels =
  {
    unstable = map.input inputs.unstable [ (final: prev: { stable = channels.nixpkgs; }) ] [ ];
    nixpkgs = map.input inputs.nixpkgs [ self.overlay inputs.nur.overlay (final: prev: { unstable = channels.unstable; }) ] ./packages/patches;
  };

  # Absolute Paths
  path = import ./path.nix;

  # Dotfiles and Program Configuration
  files = import ./files;
in
eachSystem systems (system: let pkgs = channels.nixpkgs."${system}"; in
{
  ## Configuration Checks ##
  checks = map.checks.system self.installMedia;

  ## Developer Shells ##
  # Default Developer Shell
  devShell = import ./shells { inherit pkgs; };

  # Tailored Developer Shells
  devShells = map.modules ./shells (name: import name { inherit pkgs; });

  ## Package Configuration ##
  legacyPackages = (head (attrValues self.nixosConfigurations)).pkgs;

  # Custom Packages
  defaultPackage = self.packages."${system}".nixos;
  packages = map.merge map.modules ./packages ./scripts (name: pkgs.callPackage name { inherit pkgs path files; });
})
//
{
  # Overrides
  overlay = final: prev: { custom = self.packages; };
  overlays = map.modules ./packages/overlays import;

  ## Custom Configuration Modules ##
  nixosModules = map.merge map.modules ./modules ./secrets import;

  ## Install Media Configuration ##
  installMedia =
  {
    # Install Media - GNOME
    gnome = build.system
    {
      iso = true;
      name = "nixos";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = "linux_5_15";
      desktop = "gnome-minimal";
    };
  };

  ## Device Configuration ##
  nixosConfigurations =
  {
    # PC - Dell Inspiron 15 5000
    Vortex = build.system
    {
      system = "x86_64-linux";
      name = "Vortex";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = "linux_lqx";
      kernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

      hardware =
      {
        boot = "efi";
        cores = 8;
        filesystem = "advanced";
        support = [ "mobile" "printer" "ssd" "virtualisation" ];
      };

      desktop = "gnome";
      apps =
      {
        list = [ "discord" "firefox" "git" "office" "wine" ];
        git =
        {
          name = "maydayv7";
          mail = "maydayv7@gmail.com";
        };
      };

      # User V7
      user =
      {
        name = "v7";
        description = "V 7";
        groups = [ "wheel" "keys" ];
        uid = 1000;
        shell =
        {
          choice = "zsh";
          utilities = true;
        };
      };
    };

    # PC - Dell Inspiron 11 3000
    Futura = build.system
    {
      system = "x86_64-linux";
      name = "Futura";
      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";
      kernel = "linux_5_4";
      kernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

      hardware =
      {
        boot = "efi";
        cores = 4;
        filesystem = "simple";
      };

      desktop = "gnome";
      apps.list = [ "firefox" "office" ];

      # User Navya
      user =
      {
        name = "navya";
        description = "Navya";
        shell.choice = "zsh";
      };
    };
  };
}
