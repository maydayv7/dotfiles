{ config, username, lib, pkgs, ... }:
let
  device = config.device.enable;
  iso = config.iso.enable;
in rec
{
  ## Shell Configuration ##
  config = lib.mkIf (device || iso)
  (lib.mkMerge
  [
    {
      # Console Setup
      console =
      {
        earlySetup = true;
        font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
        packages = with pkgs; [ terminus_font ];
        keyMap = "us";
      };

      # Environment Variables
      environment.variables =
      {
        EDITOR = "nano";
      };

      # Essential Utilities
      environment.systemPackages = with pkgs;
      [
        git
        git-crypt
        gparted
        killall
        parted
        unrar
        unzip
        wget
      ];
    }

    (lib.mkIf device
    {
      # Utilities
      environment.systemPackages = with pkgs;
      [
        etcher
        exa
        fd
        file
        lolcat
        neofetch
      ];

      programs =
      {
        # Command Not Found Helper
        command-not-found.enable = true;

        # GPG Key Signing
        gnupg.agent.enable = true;

        # X11 SSH Password Auth
        ssh.askPassword = "";
      };
    })
  ]);
}
