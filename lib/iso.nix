{ system, version, lib, inputs, pkgs, files, ... }:
{
  ## Install Media Configuration Function ##
  build = { name, timezone, locale, kernel, desktop }:
  let
    # Default User
    username = "nixos";

    # Install Media Configuration Modules
    iso_modules =
    [
      inputs.self.nixosModules.base
      inputs.self.nixosModules.gui
      inputs.self.nixosModules.iso
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.scripts
    ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs username files; };

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
        boot.kernelModules = [ "kvm-intel" ];
        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];

        # ISO Creation Settings
        isoImage.makeEfiBootable = true;
        isoImage.makeUsbBootable = true;
        environment.pathsToLink = [ "/libexec" ];

        # Package Configuration
        system.stateVersion = version;
        nixpkgs.pkgs = pkgs;
        nix.maxJobs = lib.mkDefault 4;
        home-manager.useGlobalPkgs = true;

        # GUI Configuration
        gui.desktop = (desktop + "-minimal");

        # System Scripts
        scripts.install = true;
      }
    ];
  };
}
