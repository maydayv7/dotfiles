## Auth Credential Programs ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules.homeManager.auth = {pkgs, ...}: {
    home.packages = [pkgs.ente-auth];
    programs.keepassxc = {
      enable = true;
      autostart = false;
    };

    xdg.mimeApps.defaultApplications = util.build.mime {
      password = ["org.keepassxc.KeePassXC.desktop"];
    };

    home = {
      persist.directories = [
        ".local/state/keepassxc"
        ".local/share/io.ente.auth"
      ];

      file.".config/keepassxc/keepassxc.ini" = {
        mutable = true;
        force = true;
        text = files.keepassxc;
      };
    };
  };
}
