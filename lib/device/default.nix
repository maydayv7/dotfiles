{ system, version, lib, user, inputs, pkgs, ... }:
{
  ## Install Media Configuration Function ##
  mkISO = { name, timezone, locale, kernel, desktop }:
  let
    # Install Media Configuration Modules
    iso_modules =
    [
      ../../modules/device/base
      ../../modules/device/gui
      ../../modules/device/scripts

      # Build Module
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = iso_modules;

        # System Configuration
        iso.enable = true;
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

        # GUI Configuration
        gui.desktop = desktop;

        # System Scripts
        scripts.install = true;
      }
    ];
  };

  ## Host Configuration Function ##
  mkHost = { name, timezone, locale, kernel, kernel_modules ? [ ], kernel_params, init_modules, modprobe ? "", cores, filesystem, ssd ? false, desktop, roles, users }:
  let
    # User Creation
    device_users = (builtins.map (u: user.mkUser u) users);

    # Device Roles Import Function
    mkRole = name: import (../../roles/device + "/${name}");
    device_roles = (builtins.map (r: mkRole r) roles);

    # Device Configuration Modules
    device_modules =
    [
      ../../modules/device/base
      ../../modules/device/gui
      ../../modules/device/hardware
      ../../modules/device/scripts
    ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_users ++ device_roles ++ device_modules;

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # System Configuration
        device.enable = true;
        networking.hostName = "${name}";
        hardware.filesystem = filesystem;
        hardware.ssd = ssd;

        # Boot Configuration
        boot.kernelPackages = kernel;
        boot.kernelModules = kernel_modules;
        boot.kernelParams = kernel_params;
        boot.initrd.availableKernelModules = init_modules;
        boot.extraModprobeConfig = modprobe;

        # Package Configuration
        system.stateVersion = version;
        nixpkgs.pkgs = pkgs;
        nix.maxJobs = lib.mkDefault cores;

        # GUI Configuration
        gui.desktop = desktop;
        gui.fonts.enable = true;

        # System Scripts
        scripts.management = true;
        scripts.setup = true;

        # Authentication Credentials
        environment.etc."nixos/secrets".source = inputs.secrets;
      }
    ];
  };
}
