{ config, lib, pkgs, ... }:
let
  pc = (config.device == "PC");
  iso = (config.device == "ISO");
in rec
{
  ## Console Configuration ##
  config = lib.mkIf (pc || iso)
  {
    # Setup
    console =
    {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };

    # Essential Utilities
    environment.systemPackages = with pkgs;
    [
      etcher
      git
      git-crypt
      gparted
      killall
      parted
      unrar
      unzip
      wget
    ];
  };
}
