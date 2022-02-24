{ config, pkgs, files, ... }:
with files; {
  # Credentials
  credentials = {
    name = "maydayv7";
    fullname = "V7";
    mail = "maydayv7@gmail.com";
    key = "8C240C0C11293EE56260601CCF616EB19C2765E4";
  };

  # Home Configuration
  home = {
    packages = [ pkgs.home-manager ];

    # Directory Symlinks
    file = {
      # Profile Picture
      ".face".source = images.profile;

      # Dotfiles
      "Projects/dotfiles".source =
        config.lib.file.mkOutOfStoreSymlink path.system;
    };
  };
}
