{ self, ... } @ inputs:
with inputs;
let
  ## Variable Declaration ##
  # Supported Architectures
  systems = [ "x86_64-linux" ];

  # NixOS Version
  version = readFile ./.version;

  # System Libraries
  inherit (lib) build map;
  lib = nixpkgs.lib // self.lib;
  inherit (builtins) mapAttrs readFile;

  # Program Configuration and `dotfiles`
  files = import ./files;
in
utils.lib.eachSystem systems
(system:
  let
    # Package Channels
    pkgs = (build.channel nixpkgs [ nur.overlay ] ./packages/patches)."${system}";
    pkgs' = (build.channel unstable [ nur.overlay ] [ ])."${system}";
  in
  {
    ## Configuration Checks ##
    checks = mapAttrs (_: name: name.config.system.build.toplevel) self.installMedia;

    ## Developer Shells ##
    # Default Developer Shell
    devShell = import ./shells { inherit pkgs; };

    # Tailored Developer Shells
    devShells = map.modules ./shells (name: import name { inherit pkgs; });

    ## Package Configuration ##
    channels = { stable = pkgs; unstable = pkgs'; };
    legacyPackages = self.channels."${system}".stable;

    # Custom Packages
    defaultPackage = self.apps."${system}".nixos;
    apps = map.modules ./scripts (name: pkgs.callPackage name { inherit lib inputs pkgs files; });
    packages = self.apps."${system}" // map.modules ./packages (name: pkgs.callPackage name { inherit lib pkgs files; });
  }
)
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
    gnome = build.system
    {
      iso = true;

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
      repo = "stable";

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
        modules = [ hardware.nixosModules.dell-inspiron-5509 ];
      };

      desktop = "gnome";
      apps =
      {
        list = [ "discord" "firefox" "git" "office" "wine" ];
        git =
        {
          name = "maydayv7";
          mail = "maydayv7@gmail.com";
          runner = true;
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
        modules = with hardware.nixosModules;
        [
          common-cpu-intel
          common-pc
          common-pc-laptop
        ];
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
