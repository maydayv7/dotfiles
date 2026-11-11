## OnlyOffice Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules.homeManager.onlyoffice = {pkgs, ...}: {
    home.packages = [pkgs.onlyoffice-desktopeditors];
    home.persist.directories = [
      ".config/onlyoffice"
      ".local/share/onlyoffice"
    ];

    xdg.mimeApps.defaultApplications = util.build.mime {
      office = ["onlyoffice-desktopeditors.desktop"];
    };
  };
}
