{ system, pkgs, home-manager, lib, user, ... }:
with builtins;
{
  mkHost = { name, initrdMods, kernelMods, kernelParams, kernelPackage, password, modprobe, modules, cpuCores, users, version }:
  let
    mkModule = name: import (../modules + "/${name}");
    sys_modules = (map (r: mkModule r) modules);
    sys_users = (map (u: user.mkUser u) users);
  in lib.nixosSystem
  {
    inherit system;
    
    modules =
    [
      {
        # Modulated Configuration Imports
        imports = sys_modules ++ sys_users;
        
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
        nix.maxJobs = lib.mkDefault cpuCores;
        system.stateVersion = version;
      }
    ];
  };
}
