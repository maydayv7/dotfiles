# Niri window manager
{ config, inputs, ... }:
let
  files = config.flake.files;
in
{
  flake.modules = {
    nixos.niri = nixosArgs: let
      inherit (nixosArgs) config lib pkgs;
      inherit (lib) mkIf mkMerge;
    in {
      imports = [
        inputs.niri.nixosModules.niri
        ./_shared
      ];

      config = mkIf (config.gui.desktop or "" == "niri") (mkMerge [
        {
          gui.fonts.enable = true;
          services = {
            gvfs.enable = true;
            gnome.gnome-keyring.enable = true;
          };
          programs = {
            xwayland.enable = true;
            seahorse.enable = true;
            niri = {
              enable = true;
              package = pkgs.niri-unstable;
            };
          };
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
      ]);
    };

    homeManager.niri = hmArgs: let
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
