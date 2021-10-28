{ config, lib, inputs, ... }:
let
  cfg = config.home.activate;
  username = config.home.username;
in rec
{
  options.home.activate = lib.mkOption
  {
    description = "User Home Activation Script";
    type = lib.types.bool;
    default = true;
  };

  ## Home Activation Script ##
  config = lib.mkIf (cfg == true)
  {
    home.activation =
    {
      screenshotsDir = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/Pictures/Screenshots
        $DRY_RUN_CMD dconf write /org/gnome/shell/extensions/screenshotlocations/save-directory "'$HOME/Pictures/Screenshots'"
      '';

      addBookmarks = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        FILE=~/.config/gtk-3.0/bookmarks
        if [ -e "$FILE" ];
        then
          echo "Bookmarks already added"
        else
          echo "Adding Bookmarks"
          $DRY_RUN_CMD mkdir -p ~/.config/gtk-3.0 $VERBOSE_ARG
          $DRY_RUN_CMD cp ${inputs.self}/modules/user/home/dotfiles/bookmarks ~/.config/gtk-3.0/ $VERBOSE_ARG
        fi
      '';

      profilePic = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        FILE=/var/lib/AccountsService/icons
        if [ -e "$FILE" ];
        then
          echo "Profile Pic already copied"
        else
          echo "Copying Profile Pic"
          $DRY_RUN_CMD sudo mkdir -p /var/lib/AccountsService/{icons,users} $VERBOSE_ARG
          echo "[User]" | sudo tee /var/lib/AccountsService/users/${username} &> /dev/null
          echo "Icon=/var/lib/AccountsService/icons/${username}" | sudo tee -a /var/lib/AccountsService/users/${username} &> /dev/null
          $DRY_RUN_CMD sudo cp -av $VERBOSE_ARG ~/.local/share/backgrounds/Profile.png /var/lib/AccountsService/icons/${username}
        fi
      '';

      importKeys = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        $DRY_RUN_CMD mkdir -p ~/.gnupg $VERBOSE_ARG
        $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/public.gpg $VERBOSE_ARG
        $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/private.gpg $VERBOSE_ARG
      '';
    };
  };
}
