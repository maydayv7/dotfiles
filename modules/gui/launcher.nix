{
  config,
  lib,
  files,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkEnableOption mkIf mkOption replaceStrings types;
  cfg = config.gui.launcher;
in {
  options.gui.launcher = {
    enable = mkEnableOption "Enable Application Launcher";
    shadow = mkOption {
      description = "Control Launcher Window Shadow";
      type = types.bool;
      default = true;
    };

    server = mkOption {
      description = "Display Server to be used by Launcher";
      type = types.enum ["x11" "wayland"];
      default = "x11";
    };

    terminal = mkOption {
      description = "Terminal to be used by Launcher";
      type = types.str;
      default = "xterm";
    };

    theme = mkOption {
      description = "Theme to be used by Launcher";
      type = types.str;
      default = "adwaita";
    };
  };

  ## ULauncher Configuration ##
  config = mkIf cfg.enable {
    # Launcher Package
    environment.systemPackages = [pkgs.ulauncher];

    user = {
      persist.directories = [".config/ulauncher" ".local/share/ulauncher"];

      # Customisation
      homeConfig = {
        home.file = with files.ulauncher; {
          # Themes
          ".config/ulauncher/user-themes" = {
            source = themes;
            recursive = true;
          };

          # Extensions
          ".config/ulauncher/ext_preferences" = {
            source = extensions;
            recursive = true;
            force = true;
          };

          # Scripts
          ".config/ulauncher/scripts.json".text = scripts;

          # Settings
          ".config/ulauncher/extensions.json".text = extension;
          ".config/ulauncher/settings.json".text =
            replaceStrings ["@terminal" "@theme"] [cfg.terminal cfg.theme] settings;
        };

        # Autostart
        systemd.user.services.ulauncher = {
          Unit.Description = "Start ULauncher";
          Install.WantedBy = ["graphical-session.target"];
          Service = {
            Type = "Simple";
            Restart = "Always";
            RestartSec = 1;
            ExecStart = pkgs.writeShellScript "ulauncher-wrapper.sh" ''
              ${files.path.systemd}
              export GDK_BACKEND=${cfg.server}
              exec ${getExe pkgs.ulauncher} --hide-window ${
                if cfg.shadow
                then ""
                else "--no-window-shadow"
              }
            '';
          };
        };
      };
    };
  };
}
