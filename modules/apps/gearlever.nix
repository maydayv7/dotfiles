## AppImage Manager ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules.homeManager.gearlever = {pkgs, ...}: {
    home.packages = [pkgs.gearlever];
    home.persist.directories = [".appimages"];
    dconf.settings."it/mijorus/gearlever".appimages-default-folder = "~/.appimages";
    xdg.mimeApps.defaultApplications = util.build.mime {
      appimage = ["it.mijorus.gearlever.desktop"];
    };
  };
}
