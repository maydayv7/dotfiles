{ system, lib, user, inputs, pkgs, ... }:
with builtins;
{
  mkHost = { name, initrdMods, kernelMods, kernelParams, kernelPackage, modprobe, modules, cpuCores, users, version, filesystem ? "ext4", ssd ? false }:
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
      inputs.impermanence.nixosModules.impermanence
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
        imports = shared_modules ++ system_modules ++ system_users;
        
        # Device Hostname
        networking.hostName = "${name}";
        
        # User Settings
        users.mutableUsers = false;
        nix.trustedUsers = [ "root" "@wheel" ];
        users.extraUsers.root.initialHashedPassword = (readFile "${inputs.secrets}/passwords/root");
        
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
      
      ## Conditional Implementation ##
      # SSD Configuration
      (if ssd == true
        then (import ../modules/hardware/ssd)
        else { }
      )
      # File System Choice
      (if filesystem == "ext4"
        then (import ../modules/filesystem/ext4)
        else (import ../modules/filesystem/btrfs)
      )
    ];
  };
}
