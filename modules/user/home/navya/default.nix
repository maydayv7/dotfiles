{ files, ... }: rec {
  config = {
    # Custom Directories
    xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";

    home.file = {
      # Profile Picture
      ".face".source = files.images.profile;

      # Wallpapers
      ".local/share/backgrounds".source = files.images.wallpapers;
    };
  };
}
