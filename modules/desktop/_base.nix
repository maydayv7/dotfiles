# Shared desktop configuration
_: {
  nixos = _: {
    gui.enable = true;

    # Utilities
    services = {
      gvfs.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    programs = {
      xwayland.enable = true;
      seahorse.enable = true;
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
  };

  home = _: {
    services = {
      poweralertd.enable = true; # Power Alerts
      mpris-proxy.enable = true; # BT Controls
    };

    home.persist.directories = [
      ".config/autostart"
      ".local/share/gvfs-metadata"
    ];
  };
}
