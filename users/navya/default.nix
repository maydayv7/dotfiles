{ config, lib, pkgs, ... }: 
let
  home-manager = import ../../repos/home-manager.nix;
in
{
  imports = [(import "${home-manager}/nixos")];
  
  # User Configuration
  users.users.navya =
  {
    isNormalUser = true;
    home = "/home/navya";
    description = "Navya";
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    useDefaultShell = true;
    passwordFile = "/etc/passwords/navya";
  };
  
  # Home Configuration
  home-manager.users.navya =
  {
    # User Nix Configuration
    nixpkgs.config =
    {
      allowUnfree = true;
    };
    
    imports =
    [
      # Configuration Modules
      (import ./modules)
    ];
  };
}
