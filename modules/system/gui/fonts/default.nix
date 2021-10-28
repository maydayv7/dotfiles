{ config, lib, pkgs, ... }:
with lib;
with builtins;
let
  cfg = config.gui.enableFonts;
in rec
{
  options.gui.enableFonts = mkOption
  {
    description = "System Fonts Configuration";
    type = types.bool;
    default = false;
  };
  
  config = mkIf (cfg == true)
  {
    ## Font Configuration ##
    fonts =
    {
      enableDefaultFonts = true;
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fontconfig =
      {
        enable = true;
        localConf = builtins.readFile ./fontconfig;
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
      custom.fonts
    ];
  };
}
