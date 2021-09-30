{ system, lib, user, inputs, pkgs, home-manager, ... }:
with builtins;
{
  mkHost = { name, initrdMods, kernelMods, kernelParams, kernelPackage, password, modprobe, modules, cpuCores, users, version }:
  let
    mkModule = name: import (../modules + "/${name}");
    system_modules = (map (r: mkModule r) modules);
    system_users = (map (u: user.mkUser u) users);
    shared_modules =
    [
      # Shared System Configuration
      ../modules/core
      ../modules/boot
      ../modules/hardware
      ../modules/networking
      
      # Authentication Credentials
      ../secrets
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
        
        # Root User Configuration
        users.extraUsers.root.passwordFile = password;
        
        # Boot Configuration
        boot.initrd.availableKernelModules = initrdMods;
        boot.kernelModules = kernelMods;
        boot.kernelParams = kernelParams;
        boot.kernelPackages = kernelPackage;
        boot.extraModprobeConfig = modprobe;
        
        # Package Configuration
        nixpkgs.pkgs = pkgs;
        nixpkgs.overlays = (import ../overlays);
        nix.maxJobs = lib.mkDefault cpuCores;
        system.stateVersion = version;
      }
    ];
  };
}
