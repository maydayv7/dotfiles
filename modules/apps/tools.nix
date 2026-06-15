## Tools Configuration ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules = {
    nixos.tools = {pkgs, ...}: {
      # Screen Record
      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-mute-filter
          obs-source-switcher
        ];
      };
    };

    homeManager.tools = {pkgs, ...}: {
      home.packages = with pkgs; [
        # Utilities
        clapgrep
        gearlever
        popsicle

        # Graphics
        drawing
        identity
        pitivi
        vipsdisp

        # Audio
        pwvucontrol
        qpwgraph
      ];

      # AppImage Manager
      dconf.settings."it/mijorus/gearlever".appimages-default-folder = "~/.appimages";
      xdg.mimeApps.defaultApplications = util.build.mime {
        appimage = ["it.mijorus.gearlever.desktop"];
      };

      # Audio Effects
      services.easyeffects.enable = true;

      home.persist = {
        files = [".config/rncbc.org/qpwgraph"];
        directories = [
          ".appimages"
          ".config/de.leopoldluley.Clapgrep"
          ".config/easyeffects"
          ".config/obs-studio"
          ".config/pitivi"
          ".local/share/easyeffects"
        ];
      };
    };
  };
}
