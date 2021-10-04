{ lib, pkgs, ... }:
{
  # Font Configuration
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
      };
    };
  };
  
  # Font Packages
  fonts.fonts = with pkgs; 
  [
      cantarell_fonts
      corefonts
      dejavu_fonts
      fira
      fira-code
      fira-mono
      inconsolata
      iosevka
      liberation_ttf
      meslo-lgs-nf
      noto-fonts
      noto-fonts-emoji
      roboto
      source-code-pro
      ttf_bitstream_vera
      ubuntu_font_family
      
      # Custom Fonts
      product-sans
  ];
}
