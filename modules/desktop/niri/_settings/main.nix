## Compositor Settings
_: {config, ...}: let
  inherit (config.lib.stylix.colors) base04 base08;
in {
  programs.niri.settings = {
    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d-%H%M%S.png";
    environment.DISPLAY = ":0"; # XWayland Support
    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    # Use 'nwg-displays' to configure monitors
    includes = [
      "monitors.kdl"
      "workspaces.kdl"
    ];

    input = {
      keyboard.numlock = true;
      mouse.accel-profile = "flat";
      warp-mouse-to-focus.enable = true;
      workspace-auto-back-and-forth = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "90%";
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = false;
      };
    };

    layout = {
      tab-indicator = {
        enable = true;
        place-within-column = true;
      };

      default-column-width.proportion = 0.5;
      preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 0.5;}
        {proportion = 2.0 / 3.0;}
        {proportion = 0.85;}
      ];
      preset-window-heights = [
        {proportion = 1.0 / 3.0;}
        {proportion = 0.5;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
    };

    # Mouse Gestures
    gestures.hot-corners = {
      top-left = true;
      top-right = false;
      bottom-left = false;
      bottom-right = false;
    };

    # Window Switcher
    recent-windows = {
      enable = true;
      open-delay-ms = 150;
      highlight = {
        active-color = "#${base04}";
        urgent-color = "#${base08}";
        padding = 30;
        corner-radius = 7;
      };
      previews = {
        max-height = 480;
        max-scale = 0.5;
      };
      binds = let
        ra = config.lib.niri.actions.recent-windows;
      in {
        "Alt+Tab".action = ra.next-window;
        "Alt+Shift+Tab".action = ra.previous-window;
        "Alt+grave".action = ra.next-window {filter = "app-id";};
        "Alt+Shift+grave".action = ra.previous-window {filter = "app-id";};
      };
    };
  };
}
