_: {config, ...}: {
  programs.niri.settings = {
    ## Autostart
    spawn-at-startup = let
      exec = app: args:
        [
          "uwsm"
          "app"
          "-t"
          "service"
          "-u"
          "${app}.service"
          "--"
          app
        ]
        ++ args;
    in [
      {
        command = [
          "uwsm"
          "finalize"
          "NIRI_SOCKET"
        ];
      }
      {command = exec "pcmanfm-qt" ["--desktop"];}
      {command = exec "nwg-drawer" ["-r"];}
      {command = exec "sunsetr" ["-b"];}
    ];

    ## Keybindings
    binds = with config.lib.niri.actions; let
      sh = spawn "sh" "-c";
      toggle = app: args: sh "pkill ${app} || uwsm app -u ${app}.scope -- ${app} ${args}";
      runOnce = app: args: sh "pgrep ${app} || uwsm app -u ${app}.scope -- ${app} ${args}";
    in {
      # Applications
      "Super+space" = {
        action = spawn "rofi" "-show" "drun";
        hotkey-overlay.title = "Launcher";
      };

      "Super+A" = {
        action = spawn "nwg-drawer";
        hotkey-overlay.title = "Application Drawer";
      };

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

      # Utilities
      "Super+N" = {
        action = spawn "swaync-client" "-t" "-sw";
        hotkey-overlay.title = "Show Notifications";
      };

      "Super+V" = {
        action = spawn "kitty" "--class=clipboard" "-e" "clipse";
        hotkey-overlay.title = "Clipboard";
      };

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

      "Super+Escape" = {
        action = toggle "wlogout" "-p layer-shell";
        hotkey-overlay.title = "Power Menu";
      };
    };

    ## Window Rules
    window-rules = [
      {
        matches = [
          {app-id = "clipboard";}
          {app-id = "qalculate-gtk";}
        ];
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
          {app-id = "com.github.wwmm.easyeffects";}
        ];
        open-floating = true;
      }
    ];
  };
}
