{ pkgs, ... }:
rec
{
  ## Console Configuration ##
  config =
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
