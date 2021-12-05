{ build, system, version, lib, util, inputs, pkgs, files, ... }:
with inputs;
let
  inherit (self) nixosModules;
  specialArgs = { inherit util inputs files; };
in
{
  ## Device Configuration Function ##
  device = { name, timezone, locale, kernel, kernelModules, hardware, desktop, apps, user }:
  lib.nixosSystem
  {
    inherit system specialArgs;
    modules =
    [{
      # Modulated Configuration Imports
      imports = with nixosModules; [ base ];
      inherit apps hardware user;

      # Device Hostname
      networking.hostName = "${name}";

      # Localization
      time.timeZone = timezone;
      i18n.defaultLocale = locale;

      # Hardware Configuration
      boot =
      {
        kernelPackages = kernel;
        initrd.availableKernelModules = kernelModules;
      };

      # Package Configuration
      nixpkgs.pkgs = pkgs;
      nix.maxJobs = lib.mkDefault hardware.cores;
      system =
      {
        stateVersion = version;
        configurationRevision = lib.mkIf (self ? rev) self.rev;
      };

      # GUI Configuration
      gui =
      {
        desktop = desktop;
        fonts.enable = true;
      };
    }];
  };

  ## Install Media Configuration Function ##
  iso = { name, timezone, locale, kernel, desktop }:
  let
    iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix";
  in lib.nixosSystem
  {
    inherit system specialArgs;
    modules =
    [{
      # Modulated Configuration Imports
      imports = with nixosModules; [ base iso ];

      # Hostname
      networking.hostName = "${name}";

      # Localization
      time.timeZone = timezone;
      i18n.defaultLocale = locale;

      # Boot Configuration
      boot =
      {
        kernelPackages = kernel;
        initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];
      };

      # User Configuration
      user =
      {
        name = "nixos";
        autologin = true;
      };

      # ISO Creation Settings
      environment.pathsToLink = [ "/libexec" ];
      isoImage =
      {
        makeEfiBootable = true;
        makeUsbBootable = true;
      };

      # Package Configuration
      nixpkgs.pkgs = pkgs;
      nix.maxJobs = lib.mkDefault 4;
      system.stateVersion = version;

      # GUI Configuration
      gui.desktop = (desktop + "-minimal");
    }];
  };
}
