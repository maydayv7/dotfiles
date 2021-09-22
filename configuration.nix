{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Modules
    ./modules
    
    # Package Overlays
    ./overlays
    
    # Personal Credentials
    ./secrets
  ];
  
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
      "nixos".source = (builtins.readFile ./volatile/path);
    };
  };
}
