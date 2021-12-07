{ system, version, lib, util, inputs, pkgs, path, files, ... }:
let
  inherit (util) map;
  inherit (inputs) self;
  inherit (builtins) attrValues;
  specialArgs = { inherit util inputs path files; };
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
      imports = attrValues self.nixosModules;
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
      environment.systemPackages = with pkgs.custom; [ nixos setup ];
      system =
      {
        configurationRevision = self.rev or null;
        nixos.label = map.label;
        stateVersion = version;
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
    # Install Media Build Module
    iso = [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" ];
  in lib.nixosSystem
  {
    inherit system specialArgs;
    modules =
    [{
      # Modulated Configuration Imports
      imports = attrValues self.nixosModules ++ iso;

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
      environment.systemPackages = with pkgs.custom; [ install ];

      # GUI Configuration
      gui.desktop = (desktop + "-minimal");
    }];
  };
}
