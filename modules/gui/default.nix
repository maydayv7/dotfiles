{
  config,
  options,
  lib,
  util,
  ...
}:
let
  inherit (util.map.modules) list name;
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    types
    ;

  inherit (config.gui) desktop;
in
{
  ## GUI Configuration ##
  imports = list ./. ++ list ./desktop;

  options.gui = {
    fancy = mkEnableOption "Enable Fancy GUI Effects";
    display = mkOption {
      description = "Main GUI Display";
      type = types.str;
      default = "eDP-1";
      example = "HDMI-A-1";
    };

    desktop = mkOption {
      description = "GUI Desktop Choice";
      type = types.enum ((name ./desktop) ++ [ "" ]);
      default = "";
    };
  };

  config = mkMerge [
    { warnings = optional (desktop == "") (options.gui.desktop.description + " is unset"); }

    ## Desktop Environment
    (mkIf (desktop != "" && desktop != "install") {
      # Utilities
      gui.fonts.enable = true;
      services = {
        gvfs.enable = true;
        gnome.gnome-keyring.enable = true;
      };
      programs = {
        xwayland.enable = true;
        seahorse.enable = true;
      };

      user = {
        homeConfig.services.mpris-proxy.enable = true;
        persist.directories = [
          ".config/autostart"
          ".local/share/gvfs-metadata"
        ];
      };

      # Environment Setup
      environment.sessionVariables = {
        "NIXOS_OZONE_WL" = "1";
        "QT_QPA_PLATFORM" = "wayland;xcb";
        "MOZ_ENABLE_WAYLAND" = "1";
        "CLUTTER_BACKEND" = "wayland";
      };

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        wlr.enable = true;
      };
    })
  ];
}
