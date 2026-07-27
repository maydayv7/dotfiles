## Compositor
_: {
  nixos = {pkgs, ...}: {
    # WM
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    # App Environment
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home = {pkgs, ...}: {
    home.persist.directories = [".config/hypr"];
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
