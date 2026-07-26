_: {
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  let
    lua = import ./_lib.nix lib;
    inherit (lua) combo bind exec env on permission;

    inherit (osConfig.gui) display;
    inherit (config.stylix) cursor;
    hyprcursor = "${cursor.name}-Hyprcursor";

    mod = "SUPER";

    unit = command: lib.head (lib.splitString " " command);
    toggle = app: "pkill ${app} || uwsm app -u ${app}.scope -- ${app}";
    runOnce = app: "pgrep ${app} || uwsm app -u ${app}.scope -- ${app}";
  in {
    ## App Environment
    # Cursor
    xdg.dataFile."icons/${hyprcursor}".source = "${cursor.package}/share/icons/${hyprcursor}";
    wayland.windowManager.hyprland.settings = {
      env = [
        (env "HYPRCURSOR_THEME" hyprcursor)
        (env "HYPRCURSOR_SIZE" (toString cursor.size))

        # QT Apps
        (env "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
      ];

      ## Autostart
      on = [
        (on "hyprland.start" ("function() "
          + lib.concatStringsSep " " (map (c: ''hl.exec_cmd("${c}");'') (
            [
              "uwsm finalize"
              "hyprctl setcursor ${hyprcursor} ${toString cursor.size}"
            ]
            ++ (map (app: "uwsm app -t service -u ${unit app}.service -- ${app}") [
              # Pyprland
              "pypr"

              # Desktop Icons
              "pcmanfm-qt --desktop"
            ])
          ))
          + " end"))
      ];

      ## Shortcuts
      bind = [
        # Applications
        (bind (combo [mod] "F") (exec "nemo"))
        (bind (combo [mod] "T") (exec "kitty"))
        (bind (combo [mod] "W") (exec "firefox"))
        (bind (combo [mod] "Return") (exec (runOnce "resources")))
        (bind (combo [mod "SHIFT"] "equal") (exec "pypr toggle calc"))
        (bind (combo [] "XF86Calculator") (exec "qalculate-gtk"))

        # Utilities
        (bind (combo [mod] "A") (exec "noctalia msg panel-toggle launcher"))
        (bind (combo [mod] "slash") (exec "${toggle "kebihelp"} show -a"))
        (bind (combo [mod "SHIFT"] "C") (exec "${runOnce "hyprpicker"} -arf hex"))
        (bind (combo [mod "SHIFT"] "B") (exec (runOnce "overskride")))
        (bind (combo [mod] "D") (exec (runOnce "nwg-displays")))
        (bind (combo [mod "SHIFT"] "P") (exec "pwvucontrol"))
        (bind (combo [mod "SHIFT"] "N") (exec "sh -c 'env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi'"))
        (bind (combo [mod] "Escape") (exec "noctalia msg panel-toggle session"))

        # Shell
        (bind (combo [mod "SHIFT"] "A") (exec "noctalia msg settings-toggle"))
        (bind (combo [mod] "Tab") (exec "noctalia msg window-switcher"))
        (bind (combo [mod] "N") (exec "noctalia msg panel-toggle notifications"))
        (bind (combo [mod] "V") (exec "noctalia msg panel-toggle clipboard"))

        # Tools
        (bind (combo [mod] "G") (exec "pypr gamemode"))
        (bind (combo [mod "SHIFT"] "D") (exec "hyprutils toggle monitor ${display}"))
        (bind (combo [mod] "S") (exec "hyprutils toggle shader"))
        (bind (combo [mod "SHIFT"] "T") (exec "pypr toggle term"))
      ];

      ## Permissions
      permission = [
        (permission "${osConfig.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped" "screencopy" "allow")
        (permission (lib.getExe pkgs.gpu-screen-recorder) "screencopy" "allow")
        (permission (lib.getExe pkgs.wl-screenrec) "screencopy" "allow")
      ];

      ## Layer Rules
      layer_rule = [
        {
          match.namespace = "^(hyprpicker)$";
          no_anim = true;
        }
        {
          match.namespace = "^(noctalia-.*)$";
          blur = true;
          ignore_alpha = 0.6;
        }
        {
          match.namespace = "^(noctalia-wallpaper)$";
          order = 1;
        }
        {
          match.namespace = "^(desktop)$";
          order = 0;
        }
      ];

      ## Window Rules
      window_rule =
        [
          # Settings
          {
            match.class = "^(gnome-control-center)$";
            stay_focused = true;
          }

          # Keybinds Viewer
          {
            match.title = "^(Kebihelp)$";
            pin = true;
            stay_focused = true;
            opacity = "0.9 override";
          }

          # Browser Windows
          {
            match.title = "^(Picture-in-[P|p]icture)$";
            float = true;
          }
          {
            match.title = "^(Sharing Indicator)$";
            workspace = "special silent";
          }
          {
            match.title = "^(.*is sharing (your screen|a window).)$";
            workspace = "special silent";
          }

          # Media Consumption
          {
            match.class = "^(mpv|.*celluloid.*|.+exe)$";
            idle_inhibit = "focus";
          }
          {
            match = {
              class = "^(firefox|brave-browser)$";
              title = "^(.*YouTube.*)$";
            };
            idle_inhibit = "focus";
          }
          {
            match.class = "^(firefox|brave-browser)$";
            idle_inhibit = "fullscreen";
          }

          # Screen Tearing
          {
            match.class = "^(.+exe)$";
            immediate = true;
          }

          # Prompt Windows
          {
            match.class = "^(xdg-desktop-portal-gtk)$";
            float = true;
            dim_around = true;
          }
        ]
        ++ (map (class: {
            # Authentication
            match.class = "^(${class})$";
            pin = true;
            dim_around = true;
            stay_focused = true;
          }) [
            "pinentry-"
            "gcr-prompter"
          ])
        ++ (map (class: {
            # Utilities
            match.class = "^(${class})$";
            float = true;
            pin = true;
            persistent_size = true;
          }) [
            "com.saivert.pwvucontrol"
            "io.github.kaii_lb.Overskride"
            "nwg-displays"
            "gnome-control-center"
            "org.gnome.Settings"
          ])
        ++ (map (title: {
            # Dialogs
            match.title = "^(${title})(.*)$";
            float = true;
          }) [
            "Library"
            "Open File"
            "Open Folder"
            "Save As"
            "Save File"
            "Select a File"
            ".*Properties"
          ]);
    };
  }
)
