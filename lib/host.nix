{ system, lib, user, inputs, pkgs, ... }:
with builtins;
{
  mkHost = { name, initrdMods, kernelMods, kernelParams, kernelPackage, modprobe, modules, cpuCores, users, version }:
  let
    # Module Import Function
    mkModule = name: import (../modules + "/${name}");
    system_modules = (map (r: mkModule r) modules);
    
    # User Creation
    system_users = (map (u: user.mkUser u) users);
    
    # Shared System Configuration Modules
    shared_modules =
    [
      ../modules/core
      ../modules/boot
      ../modules/cachix
      ../modules/hardware
      ../modules/networking
      ../modules/shell
    ];
  in lib.nixosSystem
  {
    inherit system;
    
    modules =
    [
      {
        # Modulated Configuration Imports
        imports = shared_modules ++ system_modules ++ system_users;
        
        # Device Hostname
        networking.hostName = "${name}";
        
        # User Settings
        users.mutableUsers = false;
        nix.trustedUsers = [ "root" "v7" ];
        users.extraUsers.root.passwordFile = "/etc/nixos/secrets/passwords/root";
        
        # Boot Configuration
        boot.initrd.availableKernelModules = initrdMods;
        boot.kernelModules = kernelMods;
        boot.kernelParams = kernelParams;
        boot.kernelPackages = kernelPackage;
        boot.extraModprobeConfig = modprobe;
        
        # Package Configuration
        nixpkgs.pkgs = pkgs;
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
        nix.maxJobs = lib.mkDefault cpuCores;
        system.stateVersion = version;
      }
    ];
  };
}
