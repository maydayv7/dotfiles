{ config, pkgs, files, ... }:
with files; {
  # Custom Directories
  xdg.userDirs.extraConfig.XDG_PROJECTS_DIR = "$HOME/Projects";

  # User Home
  home = {
    packages = [ pkgs.home-manager ];

    # Home Directory
    file = {
      # Profile Picture
      ".face".source = images.profile;

      # Dotfiles
      "Projects/dotfiles".source =
        config.lib.file.mkOutOfStoreSymlink path.system;
    };
  };
}
