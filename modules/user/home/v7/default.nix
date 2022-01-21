{ pkgs, files, ... }: rec {
  config = {
    home.packages = [ pkgs.home-manager ];

    # Custom Directories
    xdg.userDirs.extraConfig = {
      XDG_PROJECTS_DIR = "$HOME/Projects";
      XDG_TBD_DIR = "$HOME/Documents/TBD";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
    };

    home.file = {
      # Profile Picture
      ".face".source = files.images.profile;

      # Wallpapers
      ".local/share/backgrounds".source = files.images.wallpapers;
    };
  };
}
