# GNOME desktop environment
{ config, inputs, ... }:
let
  files = config.flake.files;
  util = config.util;
in
{
  flake.modules = {
    nixos.gnome = nixosArgs: let
      inherit (nixosArgs) config lib pkgs;
      inherit (lib) mkForce mkIf mkMerge;
    in {
      config = mkIf (config.gui.desktop or "" == "gnome") (mkMerge [
        {
          gui.fonts.enable = true;
          services = {
            gvfs.enable = true;
            gnome.gnome-keyring.enable = true;
            xserver.desktopManager.gnome.enable = true;
            displayManager.gdm.enable = true;
          };
          programs = {
            xwayland.enable = true;
            seahorse.enable = true;
          };
          environment.sessionVariables = {
            "NIXOS_OZONE_WL" = "1";
            "QT_QPA_PLATFORM" = "wayland;xcb";
            "MOZ_ENABLE_WAYLAND" = "1";
          };
          xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
          };

          stylix.base16Scheme = files.colors.adwaita;

          services.displayManager.defaultSession = "gnome";
        }
      ]);
    };

    homeManager.gnome = hmArgs: let
      inherit (hmArgs) config lib pkgs;
    in {
      services = {
        poweralertd.enable = true;
        mpris-proxy.enable = true;
      };
      home.persist.directories = [
        ".config/autostart"
        ".local/share/gvfs-metadata"
      ];
    };
  };
}
