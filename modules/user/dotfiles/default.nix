{ config, lib, inputs, ... }:
let
  cfg = config.dotfiles;
  username = config.home.username;
  path = "${inputs.self}/modules/user/dotfiles";
in rec
{
  options.dotfiles.enable = lib.mkOption
  {
    description = "User Home Dotfiles";
    type = lib.types.bool;
    default = false;
  };

  ## User Dotfiles ##
  config = lib.mkIf cfg.enable
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

    ## Activation Scripts ##
    # Screenshots Directory
    home.activation.screenshotsDir = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/Pictures/Screenshots
      $DRY_RUN_CMD dconf write /org/gnome/shell/extensions/screenshotlocations/save-directory "'$HOME/Pictures/Screenshots'"
    '';

    # GTK+ Bookmarks
    home.activation.addBookmarks = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      FILE=~/.config/gtk-3.0/bookmarks
      if [ -e "$FILE" ];
      then
        echo "Bookmarks already added"
      else
        echo "Adding Bookmarks..."
        $DRY_RUN_CMD mkdir -p ~/.config/gtk-3.0 $VERBOSE_ARG
        $DRY_RUN_CMD cp ${path}/bookmarks ~/.config/gtk-3.0/ $VERBOSE_ARG
      fi
    '';

    # Profile Picture
    home.activation.profilePic = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      FILE=/var/lib/AccountsService/icons
      if [ -e "$FILE" ];
      then
        echo "Profile Pic already copied"
      else
        echo "Copying Profile Pic..."
        $DRY_RUN_CMD sudo mkdir -p /var/lib/AccountsService/{icons,users} $VERBOSE_ARG
        echo "[User]" | sudo tee /var/lib/AccountsService/users/${username} &> /dev/null
        echo "Icon=/var/lib/AccountsService/icons/${username}" | sudo tee -a /var/lib/AccountsService/users/${username} &> /dev/null
        $DRY_RUN_CMD sudo cp -av $VERBOSE_ARG ${path}/images/Profile.png /var/lib/AccountsService/icons/${username}
      fi
    '';
  };
}
