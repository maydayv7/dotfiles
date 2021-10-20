{ lib, pkgs, ... }:
{
  ## Shell Configuration ##
  environment =
  {
    shells = with pkgs; [ bashInteractive zsh ];
    pathsToLink = [ "/share/zsh" ];
    
    # Utilities
    systemPackages = with pkgs;
    [
      lolcat
      neofetch
    ];
    
    # Environment Variables
    variables =
    {
      EDITOR = "nano";
    };
  };
  
  # Command Not Found Helper
  programs.command-not-found.enable = true;
}
