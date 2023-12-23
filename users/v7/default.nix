{
  config,
  lib,
  pkgs,
  files,
  ...
}: {
  # Personal Credentials
  credentials = {
    name = "maydayv7";
    fullname = "V7";
    mail = "maydayv7@gmail.com";
    key = "8C240C0C11293EE56260601CCF616EB19C2765E4";
  };

  # Home Configuration
  home = {
    packages = [pkgs.home-manager];

    # Directory Symlinks
    file = with files; {
      # Profile Picture
      ".face".source = images.profile;

      # Online Accounts
      ".config/goa-1.0/accounts.conf".text = builtins.readFile ./accounts.conf;

      # Dotfiles
      "Projects/dotfiles".source =
        config.lib.file.mkOutOfStoreSymlink path.system;

      # GTK+ Bookmarks
      ".config/gtk-3.0/bookmarks".text = lib.mkBefore ''
        file://${config.home.homeDirectory}/Documents/TBD TBD
      '';
    };
  };
}
