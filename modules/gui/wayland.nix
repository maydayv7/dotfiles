{
  config,
  lib,
  ...
}: {
  options.gui.wayland.enable = lib.mkEnableOption "Enable Wayland Configuration";

  ## Wayland Configuration ##
  config = lib.mkIf config.gui.wayland.enable {
    # Environment Setup
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    # Programs Support
    xdg.portal.wlr.enable = true;
    programs.xwayland.enable = true;
  };
}
