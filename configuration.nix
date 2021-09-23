{ config, lib, pkgs, ... }:
{
  # Modulated Configuration
  imports = (import ./modules) ++ (import ./device.nix);
  
  # System Configuration
  system.stateVersion = (builtins.readFile ./volatile/repos/nixos);
  users.mutableUsers = false;
  nix.trustedUsers = [ "root" "v7" ];
  
  # Environment Configuration
  environment =
  {
    pathsToLink = [ "/share/zsh" ];
    variables =
    {
      EDITOR = "nano";
    };
    shells = with pkgs; [ bashInteractive zsh ];
    etc =
    {
      # Configuration Files
      "nixos".source = (builtins.readFile ./volatile/path);
    };
  };
}
