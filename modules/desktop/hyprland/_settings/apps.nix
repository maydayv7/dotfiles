_: {
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  let
    inherit (builtins) map toString;
    inherit (lib) flatten getExe head splitString;

    inherit (osConfig.gui) display;
    inherit (config.stylix) cursor;
    hyprcursor = "${cursor.name}-Hyprcursor";

    unit = command: head (splitString " " command);
  in {
    ## App Environment
    # Cursor
    xdg.dataFile."icons/${hyprcursor}".source = "${cursor.package}/share/icons/${hyprcursor}";
    wayland.windowManager.hyprland.settings = {
      env = [
        "HYPRCURSOR_THEME, ${hyprcursor}"
        "HYPRCURSOR_SIZE, ${toString cursor.size}"

        # QT Apps
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"

        # Screenshot
        "SLURP_ARGS, -dc ${osConfig.lib.stylix.colors.base0D}"
      ];

      # Window Swallowing
      misc.swallow_regex = "^(kitty)$";

      ## Autostart
      exec-once =
        [
          "uwsm finalize"
          "hyprctl setcursor ${hyprcursor} ${toString cursor.size}"
        ]
        ++ (map (app: "uwsm app -t service -u ${unit app}.service -- " + app) [
          "hyprutils daemon"

          # Pyprland
          "pypr"

          # Application Drawer
          "nwg-drawer -r"

          # Desktop Icons
          "pcmanfm-qt --desktop"

          # Display Temperature
          "sunsetr -b"
        ]);

      ## Shortcuts
      bind = let
        toggle = app: "pkill ${app} || uwsm app -u ${app}.scope -- ${app}";
        runOnce = app: "pgrep ${app} || uwsm app -u ${app}.scope -- ${app}";
      in [
        # Applications
        "$mod, F, exec, nemo"
        "$mod, T, exec, kitty"
        "$mod, W, exec, firefox"
        "$mod, Return, exec, ${runOnce "resources"}"
        "$mod SHIFT, equal, exec, pypr toggle calc"
        ", XF86Calculator, exec, qalculate-gtk"

        # Utilities
        "$mod, A, exec, nwg-drawer"
        "$mod, slash, exec, ${toggle "kebihelp"} show -a"
        "$mod SHIFT, C, exec, ${runOnce "hyprpicker"} -arf hex"
        "$mod SHIFT, B, exec, ${runOnce "overskride"}"
        "$mod, D, exec, ${runOnce "nwg-displays"}"
        "$mod SHIFT, P, exec, pwvucontrol"
        "$mod SHIFT, N, exec, sh -c 'env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi'"
        "$mod, Escape, exec, ${toggle "wlogout"} -p layer-shell"

        # Tools
        "$mod SHIFT, A, exec, sysutils toggle service waybar"
        "$mod SHIFT, D, exec, hyprutils toggle monitor ${display}"
        "$mod, N, exec, swaync-client -t -sw"
        "$mod, S, exec, hyprutils toggle shader"
        "$mod SHIFT, T, exec, pypr toggle term"
        "$mod, V, exec, pypr show clip"
        "$mod, backslash, exec, pypr toggle emoji"
      ];

      ## Permissions
      permission = [
        "${osConfig.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow"
        "${getExe pkgs.grim}, screencopy, allow"
        "${getExe pkgs.wl-screenrec}, screencopy, allow"
      ];

      ## Layer Rules
      layerrule = [
        "no_anim on, match:namespace ^(hyprpicker)$"
        "dim_around on, match:namespace ^(hyprshell_overview)$"

        "blur on, animation fade, match:namespace ^(logout_dialog)$"
        "blur on, dim_around on, animation popin, match:namespace ^(nwg-drawer)$"

        "blur on, ignore_alpha 0, animation slide right, match:namespace ^(swaync-control-center)$"
        "blur on, ignore_alpha 0, animation slide right, match:namespace ^(swaync-notification-window)$"

        "blur on, ignore_alpha 0, match:namespace ^(waybar)$"
        "blur on, ignore_alpha 0, match:namespace ^(wlclock)$"
      ];

      ## Window Rules
      windowrule = flatten (
        [
          # Settings
          "stay_focused on, match:class ^(gnome-control-center)$"

          # Keybinds Viewer
          "pin on, stay_focused on, opacity 0.9 override, match:title ^(Kebihelp)$"

          # Browser Windows
          "float on, match:title ^(Picture-in-[P|p]icture)$"
          "workspace special silent, match:title ^(Sharing Indicator)$"
          "workspace special silent, match:title ^(.*is sharing (your screen|a window).)$"

          # Media Consumption
          "idle_inhibit focus, match:class ^(mpv|.*celluloid.*|.+exe)$"
          "idle_inhibit focus, match:class ^(firefox|brave-browser)$, match:title ^(.*YouTube.*)$"
          "idle_inhibit fullscreen, match:class ^(firefox|brave-browser)$"

          # Screen Tearing
          "immediate on, match:class ^(.+exe)$"

          # Prompt Windows
          "float on, dim_around on, match:class ^(xdg-desktop-portal-gtk)$"
        ]
        ++ (map (class: ["pin on, dim_around on, stay_focused on, match:class ^(${class})$"]) [
          # Authentication
          "pinentry-"
          "gay.vaskel.Soteria"
          "gcr-prompter"
        ])
        ++ (map (class: ["float on, pin on, persistent_size on, match:class ^(${class})$"]) [
          # Utilities
          "com.saivert.pwvucontrol"
          "io.github.kaii_lb.Overskride"
          "nwg-displays"
          "gnome-control-center"
          "org.gnome.Settings"
        ])
        ++ (map (title: ["float on, match:title ^(${title})(.*)$"]) [
          # Dialogs
          "Library"
          "Open File"
          "Open Folder"
          "Save As"
          "Save File"
          "Select a File"
          ".*Properties"
        ])
      );
    };
  }
)
