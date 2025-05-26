{
  config,
  lib,
  util,
  pkgs,
  files,
  theme,
  ...
}:
let
  inherit (builtins) map toString;
  inherit (lib) flatten getExe;
  inherit (config.gui) cursors display;
  cursor = "${cursors.name}-Hyprcursor";
in
{
  ## App Environment
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Desktop Integration
  stylix.base16Scheme = files.colors.catppuccin;
  environment.systemPackages = [ pkgs.custom.cursors ];
  gui = with theme; {
    inherit (theme) icons;

    gtk = {
      enable = true;
      theme = gtk;
    };

    qt = {
      enable = true;
      theme = qt;
      style = "kvantum";
    };
  };

  user.homeConfig = {
    # GTK Apps
    dconf.settings."org/gnome/desktop/wm/preferences" = {
      action-double-click-titlebar = "none";
      button-layout = "appmenu";
    };

    # Cursor
    xdg.dataFile."icons/${cursor}".source = "${cursors.package}/share/icons/${cursor}";
    wayland.windowManager.hyprland.settings = {
      env = [
        "HYPRCURSOR_THEME, ${cursor}"
        "HYPRCURSOR_SIZE, ${toString cursors.size}"

        # QT Apps
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"

        # Screenshot
        "SLURP_ARGS, -dc ${config.lib.stylix.colors.base0D}"
      ];

      ## Autostart
      exec-once =
        [
          "uwsm finalize"
          "hyprctl setcursor ${cursor} ${toString cursors.size}"
        ]
        ++ (map (app: "uwsm app -t service -u ${util.build.until " " app}.service -- " + app) [
          "hyprutils daemon"

          # Pyprland
          "pypr"

          # Application Drawer
          "nwg-drawer -r"

          # Desktop Icons
          "pcmanfm-qt --desktop"
        ]);

      ## Shortcuts
      bind =
        let
          toggle = app: "pkill ${app} || uwsm app -u ${app}.scope -- ${app}";
          runOnce = app: "pgrep ${app} || uwsm app -u ${app}.scope -- ${app}";
        in
        [
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
          "$mod SHIFT, P, exec, pavucontrol"
          "$mod SHIFT, N, exec, sh -c 'env XDG_CURRENT_DESKTOP=GNOME gnome-control-center wifi'"
          "$mod, Escape, exec, ${toggle "wlogout"} -p layer-shell"

          # Tools
          "$mod SHIFT, A, exec, hyprutils toggle service waybar"
          "$mod SHIFT, D, exec, hyprutils toggle monitor ${display}"
          "$mod, N, exec, dunstctl history-pop"
          "$mod, S, exec, hyprutils toggle shader"
          "$mod SHIFT, T, exec, pypr toggle term"
          "$mod, V, exec, pypr show clip"
          "$mod, backslash, exec, pypr toggle emoji"
        ];

      ## Permissions
      permission = [
        "${config.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow"
        "${getExe pkgs.grim}, screencopy, allow"
        "${getExe pkgs.wl-screenrec}, screencopy, allow"
      ];

      ## Layer Rules
      layerrule = [
        "noanim, ^(hyprpicker)$"
        "blur, ^(hyprshell_overview)$"
        "dimaround, ^(hyprshell_overview)$"
        "blur, ^(logout_dialog)$"
        "animation fade, ^(logout_dialog)$"
        "blur, ^(nwg-drawer)$"
        "dimaround, ^(nwg-drawer)$"
        "animation fade, ^(nwg-drawer)$"
        "blur, ^(waybar)$"
        "ignorealpha, ^(waybar)$"
        "blur, ^(wlclock)$"
        "ignorealpha, ^(wlclock)$"
      ];

      ## Window Rules
      windowrulev2 = flatten (
        [
          # Settings
          "stayfocused, class:^(gnome-control-center)$"

          # Keybinds Viewer
          "pin, title:^(Kebihelp)$"
          "stayfocused, title:^(Kebihelp)$"
          "opacity 0.9 override, title:^(Kebihelp)"

          # Browser Windows
          "float, title:^(Picture-in-Picture)$"
          "workspace special silent, title:^(Sharing Indicator)$"
          "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

          # Media Consumption
          "idleinhibit focus, class:^(mpv|.*celluloid.*|.+exe)$"
          "idleinhibit focus, class:^(firefox|google-chrome)$, title:^(.*YouTube.*)$"
          "idleinhibit fullscreen, class:^(firefox|google-chrome)$"

          # Screen Tearing
          "immediate, class:^(.+exe)$"

          # Prompt Windows
          "float, class:^(xdg-desktop-portal-gtk)"
          "dimaround, class:^(xdg-desktop-portal-gtk)"
        ]
        ++ (map
          (class: [
            "pin, class:^(${class})"
            "dimaround, class:^(${class})"
            "stayfocused, class:^(${class})"
          ])
          [
            "pinentry-"
            "gay.vaskel.Soteria"
            "gcr-prompter"
          ]
        )
        ++ (map
          (class: [
            # Utilities
            "float, class:^(${class})"
            "pin, class:^(${class})"
            "persistentsize, class:^(${class})"
          ])
          [
            "io.github.kaii_lb.Overskride"
            "nwg-displays"
            "org.pulseaudio.pavucontrol"
            "gnome-control-center"
            "org.gnome.Settings"
          ]
        )
        ++ (map
          (title: [
            # Dialogs
            "float, title:^(${title})(.*)$"
          ])
          [
            "Library"
            "Open File"
            "Open Folder"
            "Save As"
            "Save File"
            "Select a File"
            ".*Properties"
          ]
        )
      );
    };
  };
}
