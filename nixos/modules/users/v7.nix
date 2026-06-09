# User V7's personal configuration
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules.homeManager.v7 = {
    config,
    lib,
    pkgs,
    ...
  }: let
    homeDir = config.home.homeDirectory;
  in {
    credentials = {
      name = "maydayv7";
      fullname = "V7";
      mail = "73811274+maydayv7@users.noreply.github.com";
      key = "8C240C0C11293EE56260601CCF616EB19C2765E4";
    };

    home = {
      packages = [pkgs.home-manager];
      persist.directories = [
        "TBD"
        "Projects"
      ];

      file = {
        ".face".source = ./_v7/profile.png;
        ".config/goa-1.0/accounts.conf".text = builtins.readFile ./_v7/accounts.conf;
        "Projects/dotfiles".source = config.lib.file.mkOutOfStoreSymlink files.path.system;
        ".config/gtk-3.0/bookmarks".text = lib.mkBefore ''
          file://${homeDir}/TBD TBD
          file://${homeDir}/Projects Projects
        '';
      };
    };
  };
}
