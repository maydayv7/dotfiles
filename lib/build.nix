{ build, system, version, lib, inputs, pkgs, files, ... }:
with inputs;
{
  ## Device Configuration Function ##
  device = { name, timezone, locale, kernel, kernelModules, hardware, desktop, apps, user }:
  let
    # User Creation
    device_user = (builtins.map (u: build.user u) user);

    # Device Configuration Modules
    device_modules =
    [
      self.nixosModules.apps
      self.nixosModules.base
      self.nixosModules.gui
      self.nixosModules.hardware
      self.nixosModules.nix
      self.nixosModules.scripts
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.user
    ];
  in lib.nixosSystem
  {
    inherit system;
    specialArgs = { inherit inputs files; };

    modules =
    [
      {
        # Modulated Configuration Imports
        imports = device_modules ++ device_user;

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
        system.configurationRevision = lib.mkIf (self ? rev) self.rev;
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
    iso_user = (builtins.map (u: build.user u) user);
    user =
    [{
      username = "nixos";
      uid = 1000;
      groups = [ "wheel" ];
      password = "password";
      shell = "bash";
    }];

    # Install Media Configuration Modules
    iso_modules =
    [
      self.nixosModules.base
      self.nixosModules.gui
      self.nixosModules.nix
      self.nixosModules.scripts

      # Install Media Build Module
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
        imports = iso_modules ++ iso_user;

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
  user = { username, description ? "", groups ? [ ], uid ? 1000, shell, password ? "", autologin ? false }:
  {
    # Home Manager Modules
    imports = [ home.nixosModules.home-manager ];

    # User Creation
    _module.args = { inherit username; };
    users.users."${username}" =
    {
      # Profile
      name = username;
      description = description;
      isNormalUser = true;
      inherit uid;
      initialPassword = password;

      # Groups
      group = "users";
      extraGroups = groups;

      # Shell
      useDefaultShell = false;
      shell = pkgs."${shell}";
    };

    # User Login
    services.xserver.displayManager.autoLogin =
    {
      enable = autologin;
      user = "${username}";
    };
  };
}
