{ lib, pkgs, ... }:
{
  # Font Configuration
  fonts =
  {
    enableDefaultFonts = true;
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
  };
  
  # Font Packages
  fonts.fonts = with pkgs; 
  [
      corefonts
      dejavu_fonts
      meslo-lgs-nf
      noto-fonts
      noto-fonts-emoji
      source-code-pro
      ubuntu_font_family
  ];
}
