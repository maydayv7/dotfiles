{ config, lib, pkgs, ... }: 
{
  # User Configuration
  users.extraUsers.root =
  {
    passwordFile = "/etc/nixos/users/root/password";
  };
}
