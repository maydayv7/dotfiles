{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}@args:
let
  inherit (lib)
    getExe
    mkForce
    mkIf
    mkMerge
    replaceStrings
    ;

  inherit (config.gui) desktop;
  theme = import ./theme.nix pkgs;
in
{
  ## Hyprland Configuration ##
  config = mkIf (desktop == "hyprland") (
    mkMerge (
      # App Configuration
      (builtins.map (path: import path (args // { inherit theme; })) (util.map.modules.list ./apps))
      ++ [
        ## Environment Setup
        rec {
          programs = {
            # WM
            hyprland = {
              enable = true;
              withUWSM = true;
              xwayland.enable = true;
              package = pkgs.hyprworld.hyprland;
              portalPackage = pkgs.hyprworld.xdg-desktop-portal-hyprland;
            };

            # Login
            regreet = {
              enable = true;
              package = pkgs.greetd.regreet;
              settings.commands = {
                reboot = [
                  "systemctl"
                  "reboot"
                ];
                poweroff = [
                  "systemctl"
                  "poweroff"
                ];
              };
            };
          };

          # Session
          services = {
            displayManager.defaultSession = "Desktop";
            xserver = {
              desktopManager.runXdgAutostartIfNone = true;
              displayManager.session = [
                {
                  name = "Desktop";
                  manage = "desktop";
                  start = "uwsm start -S -F Hyprland &> /dev/null";
                }
              ];
            };

            # Greeter
            greetd.settings.default_session.command =
              with programs;
              mkForce "${getExe hyprland.package} --config ${
                pkgs.writeText "greeter.conf" (
                  replaceStrings [ "@greeter" ] [ (getExe regreet.package) ] (
                    util.build.theme {
                      inherit (config.lib.stylix) colors;
                      file = files.hyprland.greeter;
                    }
                  )
                )
              } &> /dev/null";
          };
        }
        {
          # Greeter
          environment.persist.directories = [ "/var/lib/regreet" ];
          stylix.targets.regreet.enable = true;
          programs.regreet = {
            extraCss = mkForce "";
            theme = mkForce theme.gtk;
            iconTheme = mkForce theme.icons;
          };

          # Settings
          user = {
            persist.directories = [ ".config/hypr" ];
            homeConfig.imports = [ ./settings ];
          };
        }
      ]
    )
  );
}
