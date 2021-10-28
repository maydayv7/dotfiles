{ system, lib, user, inputs, pkgs, ... }:
{
  ## Host Configuration Function ##
  mkHost = { version, name, timezone, locale, kernel, kernelMods, kernelParams, initrdMods, modprobe, cpuCores, filesystem, ssd ? false, roles, users }:
  let
    # System Roles Import Function
    mkRole = name: import (../roles/system + "/${name}");
    device_roles = (builtins.map (r: mkRole r) roles);

    # User Creation
    device_users = (builtins.map (u: user.mkUser u) users);

    # System Configuration Modules
    system_modules =
    [
      ../modules/system
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
        imports = device_roles ++ device_users ++ system_modules;

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
        nix.maxJobs = lib.mkDefault cpuCores;

        # User Settings
        users.mutableUsers = false;
        nix.trustedUsers = [ "root" "@wheel" ];
        users.extraUsers.root.initialHashedPassword = (builtins.readFile "${inputs.secrets}/passwords/root");

        # GUI Configuration
        gui.xorg.enable = true;
        gui.gnome.enable = true;
        gui.enableFonts = true;

        # System Scripts
        scripts.management = true;
      }
    ];
  };
}
