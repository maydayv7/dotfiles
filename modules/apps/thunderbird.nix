## Thunderbird Mail Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules.homeManager.thunderbird = {pkgs, ...}: {
    programs.thunderbird = {
      enable = true;
      package = pkgs.custom.betterbird;
      profiles.default = {
        isDefault = true;
        extensions = [pkgs.custom.thunderbird-tools-ng];
        settings = {
          "extensions.autoDisableScopes" = 0;
          "mail.biff.show_tray_icon" = true;
          "mail.biff.show_tray_icon_always" = true;
          "mail.minimizeToTray" = true;
          "mail.closeToTray" = true;
        };
      };
    };

    xdg.mimeApps.defaultApplications = util.build.mime {
      mail = ["thunderbird.desktop"];
    };

    home.persist.directories = [
      ".thunderbird"
      ".cache/thunderbird"
    ];
  };
}
