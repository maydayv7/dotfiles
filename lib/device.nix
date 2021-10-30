{ system, version, lib, user, inputs, pkgs, ... }:
{
  ## Install Media Configuration Function ##
  mkISO = { name, timezone, locale, kernel, desktop }:
  let
    # Install Media Configuration Modules
    iso_modules =
    [
      ../modules/iso
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    ];
  in lib.nixosSystem
  {
    inherit system;

    specialArgs =
    {
      inherit inputs;
    };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = iso_modules;

        # Device Configuration
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

        # GUI Configuration
        gui.desktop = desktop;

        # ISO Creation Settings
        isoImage.makeEfiBootable = true;
        isoImage.makeUsbBootable = true;
        environment.pathsToLink = ["/libexec" ];

        # System Scripts
        scripts.install = true;
      }
    ];
  };

  ## Host Configuration Function ##
  mkHost = { name, timezone, locale, kernel, kernelMods ? [ ], kernelParams, initrdMods, modprobe ? "", cores, filesystem, ssd ? false, desktop, roles, users }:
  let
    # Device Roles Import Function
    mkRole = name: import (../roles/device + "/${name}");
    device_roles = (builtins.map (r: mkRole r) roles);

    # User Creation
    device_users = (builtins.map (u: user.mkUser u) users);

    # Device Configuration Modules
    device_modules =
    [
      ../modules/device
      inputs.impermanence.nixosModules.impermanence
      "${inputs.unstable}/nixos/modules/services/backup/btrbk.nix"
      "${inputs.unstable}/nixos/modules/services/x11/touchegg.nix"
    ];
  in lib.nixosSystem
  {
    inherit system;

    specialArgs =
    {
      inherit inputs;
    };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_roles ++ device_users ++ device_modules;

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Device Configuration
        base.enable = true;
        networking.hostName = "${name}";
        hardware.filesystem = filesystem;
        hardware.ssd = ssd;

        # Boot Configuration
        boot.kernelPackages = kernel;
        boot.kernelModules = kernelMods;
        boot.kernelParams = kernelParams;
        boot.initrd.availableKernelModules = initrdMods;
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
