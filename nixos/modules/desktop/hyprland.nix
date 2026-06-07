# Hyprland window manager
{ config, inputs, ... }:
let
  files = config.flake.files;
  util = config.util;
in
{
  flake.modules = {
    nixos.hyprland = nixosArgs: let
      inherit (nixosArgs) config lib pkgs;
      inherit (lib) getExe getExe' mkForce mkIf mkMerge;
    in {
      # Import the existing detailed Hyprland NixOS config
      imports = [
        inputs.hyprland.nixosModules.default
        # Shared desktop utilities
        ./_shared
      ];

      config = mkIf (config.gui.desktop or "" == "hyprland") (mkMerge [
        {
          gui.fonts.enable = true;
          services = {
            gvfs.enable = true;
            gnome.gnome-keyring.enable = true;
          };
          programs = {
            xwayland.enable = true;
            seahorse.enable = true;
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

          programs.hyprland = {
            enable = true;
            package = pkgs.hyprworld.hyprland;
          };
        }
      ]);
    };

    homeManager.hyprland = hmArgs: let
      inherit (hmArgs) config lib pkgs;
    in {
      # Hyprland home-manager config
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
