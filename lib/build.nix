{ build, system, version, lib, inputs, pkgs, files, ... }:
let
  inherit (inputs.self) nixosModules;
in
{
  ## Device Configuration Function ##
  device = { name, timezone, locale, kernel, kernelModules, hardware, desktop, apps, users }:
  let
    # User Creation
    device_users = (builtins.map (u: build.user u) users);

    # Device Configuration Modules
    device_modules =
    [
      nixosModules.apps
      nixosModules.base
      nixosModules.gui
      nixosModules.hardware
      nixosModules.nix
      nixosModules.scripts
      nixosModules.secrets
      nixosModules.shell
      nixosModules.user
    ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit system inputs files; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_modules ++ device_users;

        # Device Hostname
        networking.hostName = "${name}";

        # Localization
        time.timeZone = timezone;
        i18n.defaultLocale = locale;

        # Hardware Configuration
        boot.kernelPackages = kernel;
        boot.initrd.availableKernelModules = kernelModules;
        inherit hardware;

        # Package Configuration
        system.stateVersion = version;
        system.configurationRevision = with inputs; lib.mkIf (self ? rev) self.rev;
        nixpkgs.pkgs = pkgs;
        nix.maxJobs = lib.mkDefault hardware.cores;

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

  ## Install Media Configuration Function ##
  iso = { name, timezone, locale, kernel, desktop }:
  let
    # Default User
    username = "nixos";

    # Install Media Configuration Modules
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

  ## User Configuration Function ##
  user = { username, description, groups ? [ ], uid ? 1000, shell }:
  {
    # User Creation
    _module.args = { inherit username; };
    users.users."${username}" =
    {
      # Profile
      name = username;
      description = description;
      isNormalUser = true;
      inherit uid;

      # Groups
      group = "users";
      extraGroups = groups;
    };

    # Shell Configuration
    shell.enable = true;
    shell.shell = shell;
  };
}
