{ config, lib, pkgs, ... }: 
let
  home-manager = import ../../repos/home-manager.nix;
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
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "libvirtd"];
    useDefaultShell = false;
    shell = pkgs.zsh;
    passwordFile = "/etc/secrets/password";
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
        nur = import (import ../../repos/nur.nix) { inherit pkgs; };
        unstable = import (import ../../repos/unstable.nix) { inherit pkgs; };
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
  system.activationScripts =
  {
    text =
    ''
      rm -f /var/lib/AccountsService/icons/v7
      cp -av /home/v7/.local/share/backgrounds/Profile.png /var/lib/AccountsService/icons/v7
    '';
  };
  
  # Security Settings
  security =
  {
    sudo.extraConfig =
    "
      Defaults pwfeedback
      v7 ALL=(ALL) NOPASSWD: ALL
    ";
  };
}
