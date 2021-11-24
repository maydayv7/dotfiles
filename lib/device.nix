{ system, version, files, lib, user, inputs, pkgs, ... }:
let
  device_modules = [ ../modules inputs.home.nixosModules.home-manager ];
in
{
  ## Install Media Configuration Function ##
  mkISO = { name, timezone, locale, kernel, desktop }:
  let
    # Default User
    username = "nixos";

    # Install Media Build Module
    iso_module = [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit system files username inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_modules ++ iso_module;

        # System Configuration
        device = "ISO";
        networking.hostName = "${name}";

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Boot Configuration
        boot.kernelPackages = kernel;
        boot.kernelModules = [ "kvm-intel" ];
        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];

        # ISO Creation Settings
        isoImage.makeEfiBootable = true;
        isoImage.makeUsbBootable = true;
        environment.pathsToLink = [ "/libexec" ];

        # Package Configuration
        system.stateVersion = version;
        nixpkgs.pkgs = pkgs;
        home-manager.useGlobalPkgs = true;

        # GUI Configuration
        gui.desktop = (desktop + "-minimal");

        # System Scripts
        scripts.install = true;
      }
    ];
  };

  ## Host Configuration Function ##
  mkPC = { name, timezone, locale, kernel, kernelModules, hardware, desktop, apps, users }:
  let
    # User Creation Function
    device_users = (builtins.map (u: user.mkUser u) users);
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit system files inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_modules ++ device_users;

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # System Configuration
        device = "PC";
        networking.hostName = "${name}";

        # Hardware Configuration
        boot.kernelPackages = kernel;
        boot.initrd.availableKernelModules = kernelModules;
        inherit hardware;

        # Package Configuration
        system.stateVersion = version;
        nixpkgs.pkgs = pkgs;

        # GUI Configuration
        gui.desktop = desktop;
        gui.enableFonts = true;

        # Program Configuration
        inherit apps;

        # System Scripts
        scripts.management = true;
        scripts.setup = true;
      }
    ];
  };
}
