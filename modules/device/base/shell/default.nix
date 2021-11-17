{ config, lib, pkgs, ... }:
let
  device = config.device.enable;
  iso = config.iso.enable;
in rec
{
  ## Shell Configuration ##
  config = lib.mkIf (device || iso)
  {
    # Console Setup
    console =
    {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };

    # Shell Environment
    environment =
    {
      shells = with pkgs; [ bashInteractive zsh ];
      pathsToLink = [ "/share/zsh" ];

      # Utilities
      systemPackages = with pkgs;
      [
        etcher
        exa
        fd
        file
        git
        git-crypt
        lolcat
        neofetch
        unrar
        unzip
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
