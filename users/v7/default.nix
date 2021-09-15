{ config, lib, pkgs, ... }: 
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
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
    extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd"];
    useDefaultShell = false;
    shell = pkgs.zsh;
    passwordFile = "/etc/secrets/password";
  };
  
  # Home Configuration
  home-manager.users.v7 =
  {
    # User Nix Configuration
    nixpkgs.config.allowUnfree = true;
    imports =
    [
      # Configuration Modules
      ./modules
      
      # User Overlays
      ./overlays
    ];
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
