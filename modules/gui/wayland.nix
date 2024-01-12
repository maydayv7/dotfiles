{lib, ...}: {
  options.gui.wayland.enable = lib.mkEnableOption "Enable Wayland Configuration";

  ## Wayland Configuration ##
  config = {
    # Environment Setup
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    # Legacy Programs Support
    programs.xwayland.enable = true;

    # Desktop Integration
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
