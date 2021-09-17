{ config, lib, pkgs, ... }: 
let
  home-manager = import ../../volatile/repos/home-manager.nix;
in
{
  imports = [(import "${home-manager}/nixos")];
  
  # User Configuration
  users.users.v7 =
  {
    isNormalUser = true;
    home = "/home/v7";
    description = "V 7";
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "cdrom" "disk" "kvm" "libvirtd"];
    useDefaultShell = false;
    shell = pkgs.zsh;
    passwordFile = "/etc/passwords/v7";
  };
  
  # Home Configuration
  home-manager.users.v7 =
  {
    # User Nix Configuration
    nixpkgs.config =
    {
      allowUnfree = true;
      packageOverrides = pkgs:
      {
        # Additional Repos
        nur = import (import ../../volatile/repos/nur.nix) { inherit pkgs; };
        unstable = import (import ../../volatile/repos/unstable.nix) { inherit pkgs; };
      };
    };
    
    imports =
    [
      # Configuration Modules
      (import ./modules)
      
      # User Overlays
      (import ./overlays)
    ];
  };
  
  # Security Settings
  security =
  {
    sudo.extraConfig =
    "
      v7 ALL=(ALL) NOPASSWD: ALL
    ";
  };
}
