{ system, version, lib, user, inputs, pkgs, files, ... }:
{
  ## Device Configuration Function ##
  build = { name, timezone, locale, kernel, kernelModules, hardware, desktop, apps, users }:
  let
    # User Creation
    device_users = (builtins.map (u: user.build u) users);

    # Device Configuration Modules
    device_modules =
    [
      inputs.self.nixosModules.apps
      inputs.self.nixosModules.base
      inputs.self.nixosModules.gui
      inputs.self.nixosModules.hardware
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.scripts
      inputs.self.nixosModules.secrets
      inputs.self.nixosModules.shell
      inputs.self.nixosModules.user
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
}
