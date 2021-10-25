{ lib, inputs, username, pkgs, ... }:
{
  # Home Activation Script
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
        echo Bookmarks already added
      else
        $DRY_RUN_CMD cp ${inputs.self}/users/dotfiles/bookmarks ~/.config/gtk-3.0/ $VERBOSE_ARG
      fi
    '';
    
    profilePic = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      FILE=/var/lib/AccountsService/icons/${username}
      if [ -e "$FILE" ];
      then
        echo Profile Pic already copied
      else
        $DRY_RUN_CMD sudo cp -av $VERBOSE_ARG ~/.local/share/backgrounds/Profile.png /var/lib/AccountsService/icons/${username}
      fi
    '';
    
    importKeys = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      FILE=~/.ssh
      if [ -e "$FILE" ];
      then
        echo "Keys already imported"
      else
        $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/public.gpg $VERBOSE_ARG
        $DRY_RUN_CMD gpg --import ${inputs.secrets}/gpg/private.gpg $VERBOSE_ARG
        $DRY_RUN_CMD cp ${inputs.secrets}/ssh ~/.ssh -r $VERBOSE_ARG
        $DRY_RUN_CMD chmod 600 ~/.ssh
        $DRY_RUN_CMD ssh-add
      fi
    '';
  };
}
