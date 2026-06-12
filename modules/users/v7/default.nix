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
      mail = "maydayv7@gmail.com";
      key = "8C240C0C11293EE56260601CCF616EB19C2765E4";
    };

    home = {
      packages = [pkgs.home-manager];
      persist.directories = [
        "TBD"
        "Projects"
      ];

      file = {
        ".face".source = ./profile.png;
        ".config/goa-1.0/accounts.conf".text = builtins.readFile ./accounts.conf;
        "Projects/dotfiles".source = config.lib.file.mkOutOfStoreSymlink files.path.system;
        ".config/gtk-3.0/bookmarks".text = lib.mkBefore ''
          file://${homeDir}/TBD TBD
          file://${homeDir}/Projects Projects
        '';
      };
    };
  };
}
