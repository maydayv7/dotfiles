## Auth Credential Programs ##
{config, ...}: let
  inherit (config) util;
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

    home.persist.directories = [
      ".config/keepassxc"
      ".cache/keepassxc"
      ".local/share/io.ente.auth"
    ];
  };
}
