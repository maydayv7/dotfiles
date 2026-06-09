{
  util ? null,
  files ? null,
  inputs ? null,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
} @ args: let
  inherit
    (lib)
    getExe
    getExe'
    mkForce
    mkIf
    mkMerge
    replaceStrings
    ;
in {
  ## Hyprland Configuration ##
  imports = [(import ../_shared {inherit util files inputs;})];
  config = mkIf (config.gui.desktop == "hyprland") (
    mkMerge (
      # App Configuration
      (builtins.map (path: (import path {inherit util files inputs;}) args) (
        util.map.modules.list ./apps
      ))
      ++ [
        ## Environment Setup
        rec {
          # WM
          programs.hyprland = {
            enable = true;
            withUWSM = true;
            xwayland.enable = true;
            package = pkgs.hyprworld.hyprland;
            portalPackage = pkgs.hyprworld.xdg-desktop-portal-hyprland;
          };

          # Greeter
          services.greetd.settings.default_session.command = mkForce "${getExe' programs.hyprland.package "start-hyprland"} -- --config ${
            pkgs.writeText "greeter.conf" (
              replaceStrings ["@greeter"] [(getExe config.programs.regreet.package)] (
                util.build.theme {
                  inherit (config.lib.stylix) colors;
                  file = files.hyprland.greeter;
                }
              )
            )
          } &> /dev/null";
        }
        {
          # App Environment
          xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

          # Settings
          _shared.enable = true;
          user.homeConfig = {
            imports = builtins.map (
              p:
                import p {
                  inherit util files;
                  sys = config;
                }
            ) (util.map.modules.list ./settings);
            home.persist.directories = [".config/hypr"];
          };
        }
      ]
    )
  );
}
