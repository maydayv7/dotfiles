{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  config = mkIf (cfg == true)
  {
    # Console Setup
    console =
    {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };
    
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
        etcher
        git
        git-crypt
        unzip
        unrar
        wget
      ];
      
      # Environment Variables
      variables =
      {
        EDITOR = "nano";
      };
    };
    
    programs =
    {
      # Command Not Found Helper
      command-not-found.enable = true;
      
      # GPG Key Signing
      gnupg.agent.enable = true;
      
      # X11 SSH Password Auth
      ssh.askPassword = "";
    };
  };
}
