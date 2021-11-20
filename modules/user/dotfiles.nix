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
      ".local/share/backgrounds".source = ../../config/wallpapers;

      # Neofetch Config
      ".config/neofetch/config.conf".source = ../../config/neofetch/config.conf;

      # GTK+ Bookmarks
      ".config/gtk-3.0/bookmarks".source = ../../config/gnome/bookmarks;

      # X11 Gestures
      ".config/touchegg/touchegg.conf".source = ../../config/touchegg/touchegg.conf;

      # Document Templates
      "Templates" =
      {
        source = ../../config/templates;
        recursive = true;
      };

      # Font Rendering
      ".local/share/fonts" =
      {
        source = ../../config/fonts;
        recursive = true;
      };
    };

    # Xorg Configuration
    xresources.extraConfig = (builtins.readFile ../../config/xorg/xresources);
  };
}
