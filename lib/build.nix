{ build, system, version, lib, util, inputs, pkgs, files, ... }:
with inputs;
let
  inherit (self) nixosModules;
  specialArgs = { inherit util inputs files; };

  # Shared Configuration Modules
  common =
  [
    nixosModules.base
    nixosModules.gui
    nixosModules.nix
    nixosModules.scripts
    nixosModules.user
    nixosModules.secrets
  ];
in
{
  ## Device Configuration Function ##
  device = { name, timezone, locale, kernel, kernelModules, hardware, desktop, apps, user }:
  let
    # Device Configuration Modules
    modules =
    [
      nixosModules.apps
      nixosModules.hardware
      nixosModules.shell
    ];
  in lib.nixosSystem
  {
    inherit system specialArgs;
    modules =
    [{
      # Modulated Configuration Imports
      imports = common ++ modules;
      inherit apps hardware user;

      # Device Hostname
      networking.hostName = "${name}";

      # Localization
      time.timeZone = timezone;
      i18n.defaultLocale = locale;

      # Hardware Configuration
      boot.kernelPackages = kernel;
      boot.initrd.availableKernelModules = kernelModules;

      # Package Configuration
      system.stateVersion = version;
      system.configurationRevision = lib.mkIf (self ? rev) self.rev;
      nixpkgs.pkgs = pkgs;
      nix.maxJobs = lib.mkDefault hardware.cores;

      # GUI Configuration
      gui.desktop = desktop;
      gui.fonts.enable = true;
    }];
  };

  ## Install Media Configuration Function ##
  iso = { name, timezone, locale, kernel, desktop }:
  let
    # Install Media Build Module
    module = [ "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" ];
  in lib.nixosSystem
  {
    inherit system specialArgs;
    modules =
    [{
      # Modulated Configuration Imports
      imports = common ++ module;
      user = { name = "nixos"; autologin = true; };

      # Hostname
      networking.hostName = "${name}";

      # Localization
      time.timeZone = timezone;
      i18n.defaultLocale = locale;

      # Boot Configuration
      boot.kernelPackages = kernel;
      boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];

      # ISO Creation Settings
      isoImage.makeEfiBootable = true;
      isoImage.makeUsbBootable = true;
      environment.pathsToLink = [ "/libexec" ];

      # Package Configuration
      system.stateVersion = version;
      nixpkgs.pkgs = pkgs;
      nix.maxJobs = lib.mkDefault 4;

      # GUI Configuration
      gui.desktop = (desktop + "-minimal");
    }];
  };
}
