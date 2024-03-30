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
      "float, title:^(clipman)$"

      # Application Launcher
      "opacity 0.9 override, class:^(ulauncher)$"
      "move cursor -50% -50%, class:^(ulauncher)$"

      # Browser Windows
      "float, title:^(Picture-in-Picture)$"
      "workspace special silent, title:^(Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # Media Consumption
      "idleinhibit focus, class:^(mpv|.*celluloid.*|.+exe)$"
      "idleinhibit focus, class:^(firefox|google-chrome)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox|google-chrome)$"

      # Prompt Windows
      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
      "stayfocused, class:^(polkit-gnome-authentication-agent-1)"
      "stayfocused, class:^(pinentry-)"

      # Screen Share
      "maxsize 1 1, class:^(xwaylandvideobridge)$"
      "noanim, class:^(xwaylandvideobridge)$"
      "noblur, class:^(xwaylandvideobridge)$"
      "noinitialfocus, class:^(xwaylandvideobridge)$"
      "opacity 0.0 override 0.0 override, class:^(xwaylandvideobridge)$"
    ];
  };
}
