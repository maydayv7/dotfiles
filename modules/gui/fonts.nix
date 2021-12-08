{ config, system, lib, pkgs, files, ... }:
let
  enable = config.gui.fonts.enable;
in rec
{
  options.gui.fonts.enable = lib.mkEnableOption "Enable Fonts Configuration";

  ## Font Configuration ##
  config = lib.mkIf enable
  {
    fonts =
    {
      enableDefaultFonts = true;
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fontconfig =
      {
        enable = true;
        localConf = files.fonts.config;
        defaultFonts =
        {
          monospace = [ "MesloLGS NF" ];
          sansSerif = [ "Product Sans" ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

    # Font Packages
    fonts.fonts = with pkgs;
    [
      corefonts
      dejavu_fonts
      fira
      fira-code
      fira-mono
      liberation_ttf
      meslo-lgs-nf
      noto-fonts
      noto-fonts-emoji
      roboto
      source-code-pro
      ttf_bitstream_vera
      ubuntu_font_family

      # Patched Nerd Fonts
      (nerdfonts.override
      {
        fonts =
        [
          "FiraCode"
          "FiraMono"
          "Hack"
          "JetBrainsMono"
          "RobotoMono"
          "SourceCodePro"
        ];
      })

      # Custom Fonts
      custom."${system}".fonts
    ];
  };
}
