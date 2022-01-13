{ self, ... } @ inputs:
with inputs;
let
  ## Variable Declaration ##
  # Supported Architectures
  systems = [ "x86_64-linux" ];

  # NixOS Version
  version = readFile ./.version;

  # System Libraries
  inherit (lib) map package;
  lib = nixpkgs.lib // self.lib;
  build = self.nixosModule.config;
  inherit (builtins) attrValues head mapAttrs readFile;

  # Package Channels
  channels =
  {
    unstable = package.channel unstable [ self.overlay ] [ ];
    nixpkgs = package.channel nixpkgs [ self.overlay nur.overlay ] ./packages/patches;
  };

  # Program Configuration and dotfiles
  files = import ./files;
in
utils.lib.eachSystem systems (system: let pkgs = channels.nixpkgs."${system}"; in
{
  ## Configuration Checks ##
  checks = mapAttrs (_: name: name.config.system.build.toplevel) self.installMedia;

  ## Developer Shells ##
  # Default Developer Shell
  devShell = import ./shells { inherit pkgs; };

  # Tailored Developer Shells
  devShells = map.modules ./shells (name: import name { inherit pkgs; });

  ## Package Configuration ##
  channels = { stable = pkgs; unstable = channels.unstable."${system}"; };
  legacyPackages = (head (attrValues self.nixosConfigurations)).pkgs;

  # Custom Packages
  defaultPackage = self.packages."${system}".nixos;
  packages = map.merge map.modules ./packages ./scripts (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
})
//
{
  # Overrides
  overlay = final: prev: { home-manager = prev.callPackage "${inputs.home}/home-manager" { }; };
  overlays = map.modules ./packages/overlays import;

  ## Custom Library Functions ##
  lib = import ./lib { inherit systems inputs; lib = nixpkgs.lib; };

  ## Custom Configuration Modules ##
  nixosModule = import ./modules { inherit systems version lib inputs files; };
  nixosModules = map.merge map.modules ./modules ./secrets import;

  ## Install Media Configuration ##
  installMedia =
  {
    # Install Media - GNOME
    gnome = build
    {
      iso = true;
      name = "nixos";
      repo = channels.nixpkgs;

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
    Vortex = build
    {
      system = "x86_64-linux";
      name = "Vortex";
      repo = channels.nixpkgs;

      timezone = "Asia/Kolkata";
      locale = "en_IN.UTF-8";

      kernel = "linux_lqx";
      kernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

      hardware =
      {
        boot = "efi";
        cores = 8;
        filesystem = "advanced";
        modules = [ hardware.nixosModules.dell-inspiron-5509 ];
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
    Futura = build
    {
      system = "x86_64-linux";
      name = "Futura";
      repo = channels.nixpkgs;

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
