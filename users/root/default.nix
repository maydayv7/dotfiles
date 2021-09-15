{ config, lib, pkgs, ... }: 
{
  # Root User Configuration
  users.extraUsers.root =
  {
    passwordFile = "/etc/nixos/users/root/password";
  };
}
