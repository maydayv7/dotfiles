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
        emoji = ["Noto Color Emoji"];
      };
    };
  };
  
  # Font Packages
  fonts.fonts = with pkgs; 
  [
      cantarell_fonts
      nur.repos.mic92.clearsans
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
      custom.product-sans
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
          "FantasqueSansMono"
          "Hack"
          "JetBrainsMono"
          "Meslo"
          "RobotoMono"
          "SourceCodePro"
        ];
      })
  ];
}
