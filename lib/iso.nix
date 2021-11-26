{ system, version, lib, inputs, pkgs, ... }:
{
  ## Install Media Configuration Function ##
  build = { name, timezone, locale, kernel, desktop }:
  let
    # Default User
    username = "nixos";

    # Install Media Configuration Modules
    inherit (inputs.self) nixosModules;
    iso_modules =
    [
      nixosModules.base
      nixosModules.gui
      nixosModules.iso
      nixosModules.nix
      nixosModules.scripts
    ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs username; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = iso_modules;

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

        # System Scripts
        scripts.install = true;
      }
    ];
  };
}
