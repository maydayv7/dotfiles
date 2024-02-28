_: {
  wayland.windowManager.hyprland.settings = {
    ## Layer Rules
    layerrule = [
      "blur, ^(waybar)$"
      "blur, ^(gtk-layer-shell)$"
    ];

    ## Window Rules
    windowrulev2 = [
      # Clipboard
      "float, title:^(nwg-clipman)$"

      # Application Launcher
      "opacity 0.9 override, class:^(ulauncher)$"

      # PiP Window
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # Throw away Sharing Window
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # Idle Inhibit during media consumption
      "idleinhibit focus, class:^(mpv|.+exe)$"
      "idleinhibit focus, class:^(firefox|google-chrome)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox|google-chrome)$"

      # Prompt Windows
      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # Screen Share
      "maxsize 1 1, class:^(xwaylandvideobridge)$"
      "noanim, class:^(xwaylandvideobridge)$"
      "noblur, class:^(xwaylandvideobridge)$"
      "noinitialfocus, class:^(xwaylandvideobridge)$"
      "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
    ];
  };
}
