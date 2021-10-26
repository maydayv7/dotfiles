{ system, lib, user, inputs, pkgs, ... }:
with builtins;
{
  mkHost = { name, initrdMods, kernelMods, kernelParams, kernelPackage, modprobe, roles, cpuCores, users, version, filesystem ? "ext4", ssd ? false }:
  let
    # Roles Import Function
    mkRole = name: import (../roles + "/${name}");
    system_roles = (map (r: mkRole r) roles);
    
    # User Creation
    system_users = (map (u: user.mkUser u) users);
    
    # Shared System Roles
    shared_roles =
    [
      ../roles/core
      ../roles/boot
      ../roles/cachix
      ../roles/hardware
      ../roles/networking
      ../roles/shell
    ];
    
    # Extra Configuration Modules
    extra_modules =
    [
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
        imports = shared_roles ++ system_roles ++ system_users ++ extra_modules;
        
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
        then (import ../roles/hardware/ssd)
        else { }
      )
      # File System Choice
      (if filesystem == "btrfs"
        then (import ../roles/filesystem/btrfs)
        else (import ../roles/filesystem/ext4)
      )
    ];
  };
}
