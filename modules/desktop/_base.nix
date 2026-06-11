# Shared desktop environment configuration (applied to any graphical desktop)
_: {
  # Mark this host as running a graphical desktop session
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
}
