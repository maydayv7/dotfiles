{
  config,
  pkgs,
  ...
}: let
  font = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
in {
  ## Console Configuration ##
  config = {
    # Setup
    console = {
      earlySetup = true;
      packages = [pkgs.terminus_font];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
      useXkbConfig = true;
    };

    # TTY
    services.kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        font-name=${font}
        font-size=14
      '';
    };
  };
}
