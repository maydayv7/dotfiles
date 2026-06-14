## Font Configuration ##
_: {
  flake.modules.nixos.fonts = {
    config,
    pkgs,
    ...
  }: {
    fonts = {
      enableDefaultPackages = true;
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
          emoji = [config.stylix.fonts.emoji.name];
        in {
          monospace = emoji;
          sansSerif = emoji;
          serif = emoji;
        };
      };
    };

    # Font Sizes
    stylix.fonts = {
      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };
      serif = {
        package = pkgs.eb-garamond;
        name = "EB Garamond";
      };
      monospace = {
        package = pkgs.custom.fonts;
        name = "Iosvmata";
      };
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 10;
        terminal = 12;
      };
    };

    # Font Packages
    fonts.packages = with pkgs; [
      font-awesome
      nerd-fonts.symbols-only
      noto-fonts
      symbola
      fira
      fira-code
      fira-mono
      ibm-plex
      roboto
      roboto-mono
      roboto-slab
      source-code-pro
      ubuntu-classic
    ];
  };
}
