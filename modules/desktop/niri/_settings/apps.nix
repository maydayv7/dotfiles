_: {
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri.settings = {
    ## Autostart
    spawn-at-startup = let
      exec = app: args: [app] ++ args;
    in [
      {command = exec "pcmanfm-qt" ["--desktop"];}
      {command = [(lib.getExe pkgs.xwayland-satellite) ":0"];}
    ];

    ## Keybindings
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
      runOnce = app: args: sh "pgrep ${app} || ${app} ${args}";
    in {
      # Applications
      "Super+F" = {
        action = spawn "nemo";
        hotkey-overlay.title = "Files";
      };

      "Super+T" = {
        action = spawn "kitty";
        hotkey-overlay.title = "Terminal";
      };

      "Super+W" = {
        action = spawn "firefox";
        hotkey-overlay.title = "Browser";
      };

      "Super+Return" = {
        action = runOnce "resources" "";
        hotkey-overlay.title = "Task Manager";
      };

      "XF86Calculator" = {
        action = spawn "qalculate-gtk";
        hotkey-overlay.title = "Calculator";
      };

      # Shell
      "Super+A" = {
        action = sh "noctalia msg panel-toggle launcher";
        hotkey-overlay.title = "Launcher";
      };

      "Super+Shift+A" = {
        action = sh "noctalia msg settings-toggle";
        hotkey-overlay.title = "Settings";
      };

      "Super+N" = {
        action = sh "noctalia msg panel-toggle notifications";
        hotkey-overlay.title = "Notifications";
      };

      "Super+V" = {
        action = sh "noctalia msg panel-toggle clipboard";
        hotkey-overlay.title = "Clipboard";
      };

      "Super+Escape" = {
        action = sh "noctalia msg panel-toggle session";
        hotkey-overlay.title = "Power Menu";
      };

      # Utilities
      "Super+Shift+C" = {
        action = runOnce "hyprpicker" "-arf hex";
        hotkey-overlay.title = "Color Picker";
      };

      "Super+Shift+B" = {
        action = runOnce "overskride" "";
        hotkey-overlay.title = "Bluetooth Settings";
      };

      "Super+Shift+N" = {
        action = sh "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi";
        hotkey-overlay.title = "Network Settings";
      };

      "Super+Shift+P" = {
        action = spawn "pwvucontrol";
        hotkey-overlay.title = "Audio Settings";
      };

      "Super+D" = {
        action = runOnce "nwg-displays" "";
        hotkey-overlay.title = "Display Settings";
      };
    };

    ## Window Rules
    window-rules = [
      {
        matches = [{app-id = "qalculate-gtk";}];
        open-floating = true;
        default-column-width.proportion = 0.5;
        default-window-height.proportion = 0.9;
        default-floating-position = {
          relative-to = "right";
          x = 5;
          y = 0;
        };
      }
      {
        matches = [
          {app-id = "com.saivert.pwvucontrol";}
          {app-id = "io.github.kaii_lb.Overskride";}
          {app-id = "nwg-displays";}
          {app-id = "org.gnome.Settings";}
          {app-id = "gnome-control-center";}
        ];
        open-floating = true;
      }
    ];
  };
}
