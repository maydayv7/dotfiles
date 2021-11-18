{ config, lib, inputs, ... }:
let
  enable = config.dotfiles.enable;
in rec
{
  options.dotfiles.enable = lib.mkOption
  {
    description = "User Home Dotfiles";
    type = lib.types.bool;
    default = false;
  };

  ## User Dotfiles ##
  config = lib.mkIf enable
  {
    home.file =
    {
      # Wallpapers
      ".local/share/backgrounds".source = ./images;

      # Neofetch Config
      ".config/neofetch/config.conf".source = ./fetch;

      # GTK+ Bookmarks
      ".config/gtk-3.0/bookmarks".source = ./bookmarks;

      # X11 Gestures
      ".config/touchegg/touchegg.conf".source = ./gestures;

      # Document Templates
      "Templates" =
      {
        source = ./templates;
        recursive = true;
      };

      # Font Rendering
      ".local/share/fonts" =
      {
        source = ./fonts;
        recursive = true;
      };
    };

    # Xorg Configuration
    xresources.extraConfig = (builtins.readFile ./xorg);
  };
}
