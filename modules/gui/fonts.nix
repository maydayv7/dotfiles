{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gui.fonts.enable = lib.mkEnableOption "Enable Fonts Configuration";

  ## Font Configuration ##
  config = lib.mkIf config.gui.fonts.enable rec {
    fonts = {
      enableDefaultPackages = false;
      fontDir.enable = true;

      ## Render Settings
      fontconfig = {
        enable = true;

        hinting = {
          enable = true;
          autohint = false;
          style = "slight";
        };

        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };

        # Emoji Support
        defaultFonts = let
          emoji = [stylix.fonts.emoji.name];
        in {
          monospace = emoji;
          sansSerif = emoji;
          serif = emoji;
        };
      };
    };

    stylix.fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.custom.fonts;
        name = "Product Sans";
      };

      monospace = {
        package = pkgs.meslo-lgs-nf;
        name = "MesloLGS NF";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Font Packages
    fonts.packages = with pkgs; [
      corefonts
      gyre-fonts
      unifont

      fira
      fira-code
      fira-mono
      roboto
      roboto-slab
      source-code-pro
      ubuntu_font_family

      # Patched Nerd Fonts
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "RobotoMono"
          "SourceCodePro"
        ];
      })
    ];
  };
}
