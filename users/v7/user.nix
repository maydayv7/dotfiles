{ config, lib, pkgs, ... }: 
{
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
    passwordFile = "/etc/nixos/users/v7/password";
  };
  
  # Home Configuration
  imports = [(import ./home.nix)];
  
  # Security Configuration
  security =
  {
    sudo.extraConfig =
    "
      Defaults pwfeedback
      v7 ALL=(ALL) NOPASSWD: ALL
    ";
  };
}
