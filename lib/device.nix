{ system, version, files, secrets, lib, user, inputs, pkgs, ... }:
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
        imports = [ ../modules ] ++ [ "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" ];

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

        # GUI Configuration
        gui.desktop = (desktop + "-minimal");

        # System Scripts
        scripts.install = true;
      }
    ];
  };

  ## Host Configuration Function ##
  mkPC = { name, timezone, locale, kernel, kernelModules, hardware, desktop, users }:
  lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit files secrets inputs; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = [ ../modules ] ++ (builtins.map (u: user.mkUser u) users);

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

        # System Scripts
        scripts.management = true;
        scripts.setup = true;
      }
    ];
  };
}
