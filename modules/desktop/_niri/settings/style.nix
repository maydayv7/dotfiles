{sys ? null, ...}: _:
with sys.lib.stylix.colors.withHashtag; {
  programs.niri.settings = {
    prefer-no-csd = true;
    overview.backdrop-color = base00;
    layout = {
      gaps = 7;
      background-color = base00;
      insert-hint.display.color = base05;

      shadow = {
        enable = true;
        spread = 4;
        softness = 8;
        offset = {
          x = 0;
          y = 0;
        };
      };

      border.width = 1;
      focus-ring = {
        enable = true;
        width = 1;
        active.color = base0D;
      };

      tab-indicator = {
        position = "left";
        length.total-proportion = 1.0;
        width = 7;
        gap = 7;
        gaps-between-tabs = 7;
        corner-radius = 7;
      };
    };

    window-rules = [
      {
        clip-to-geometry = true;
        draw-border-with-background = false;
        geometry-corner-radius = let
          radius = 7.0;
        in {
          bottom-left = radius;
          bottom-right = radius;
          top-left = radius;
          top-right = radius;
        };
      }
    ];
  };
}
