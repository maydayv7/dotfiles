_: {
  ## Window Rules
  wayland.windowManager.hyprland.settings.windowrulev2 = [
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
  ];
}
