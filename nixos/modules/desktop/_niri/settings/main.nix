{sys ? null, ...}: _:
with sys.lib.stylix.colors; {
  programs.niri.settings = {
    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d-%H%M%S.png";
    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    input = {
      keyboard.numlock = true;
      warp-mouse-to-focus.enable = true;
      workspace-auto-back-and-forth = true;
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "90%";
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
  };

  programs.niri.extraConfig = ''
    recent-windows {
      open-delay-ms 150

      binds {
        Alt+Tab         { next-window; }
        Alt+Shift+Tab   { previous-window; }
        Alt+grave       { next-window     filter="app-id"; }
        Alt+Shift+grave { previous-window filter="app-id"; }
      }

      highlight {
        active-color "#${base04}"
        urgent-color "#${base08}"
        padding 30
        corner-radius 7
      }

      previews {
        max-height 480
        max-scale 0.5
      }
    }

    gestures {
      hot-corners {
        top-right
        bottom-right
      }
    }
  '';
}
