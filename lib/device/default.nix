{ system, version, lib, user, inputs, pkgs, ... }:
{
  ## Install Media Configuration Function ##
  mkISO = { name, timezone, locale, kernel, desktop }:
  lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = [ ../../modules/device/iso ];

        # Hardware Configuration
        base.enable = true;
        networking.hostName = "${name}";

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Boot Configuration
        boot.kernelPackages = kernel;
        boot.kernelModules = [ "kvm-intel" ];
        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];

        # Package Configuration
        system.stateVersion = version;
        nixpkgs.pkgs = pkgs;

        # ISO Creation Settings
        isoImage.makeEfiBootable = true;
        isoImage.makeUsbBootable = true;
        environment.pathsToLink = [ "/libexec" ];

        # GUI Configuration
        gui.desktop = (desktop + "-minimal");

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
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_users ++ device_roles ++ [ ../../modules/device ];

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Hardware Configuration
        base.enable = true;
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

        # User Settings
        users.mutableUsers = false;
        users.extraUsers.root.initialHashedPassword = (builtins.readFile "${inputs.secrets}/passwords/root");

        # GUI Configuration
        gui.desktop = desktop;
        gui.enableFonts = true;

        # System Scripts
        scripts.management = true;
        scripts.setup = true;
      }
    ];
  };
}
