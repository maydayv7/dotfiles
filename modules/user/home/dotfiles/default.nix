{ config, lib, ... }:
let
  cfg = config.home.dotfiles;
in rec
{
  options.home.dotfiles = lib.mkOption
  {
    description = "User Home Dotfiles";
    type = lib.types.bool;
    default = false;
  };

  ## User Dotfiles ##
  config = lib.mkIf (cfg == true)
  {
    home.file =
    {
      # Wallpapers
      ".local/share/backgrounds".source = ./images;

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
