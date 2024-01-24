{
  config,
  lib,
  files,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption replaceStrings types;
  cfg = config.gui.launcher;
  shadow =
    if config.gui.compositor.enable
    then "--no-window-shadow"
    else "";
in {
  options.gui.launcher = {
    enable = mkEnableOption "Enable Application Launcher";

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
            ExecStart = pkgs.writeShellScript "ulauncher-env-wrapper.sh" ''
              export PATH="''${XDG_BIN_HOME}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
              export GDK_BACKEND=x11
              exec ${pkgs.ulauncher}/bin/ulauncher --hide-window ${shadow}
            '';
          };
        };
      };
    };
  };
}
