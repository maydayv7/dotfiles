{
  lib,
  pkgs,
  ...
}: {
  ## Picom Compositor Configuration ##
  services.picom = rec {
    enable = true;
    package = pkgs.unstable.picom;

    # Driver
    backend = "egl";
    vSync = true;

    # Shadows
    shadow = true;
    shadowExclude = [
      "name = 'cpt_frame_xcb_window'"
      "class_g ?= 'zoom'"
      "name *= 'Chrome'"
      "class_g = 'firefox' && argb"
      "class_g = 'thunderbird' && argb"
      "_NET_WM_STATE@[*]:a = '_NET_WM_STATE_HIDDEN'"
    ];

    # Opacity
    opacityRules = [
      "95:class_g = 'Code'"
      "95:class_g = 'Ulauncher'"
    ];

    wintypes = {
      tooltip = {opacity = 0.8;};
      popup_menu = {opacity = 0.9;};
      dropdown_menu = {opacity = 0.9;};
    };

    settings =
      # Behaviour
      {
        inactive-dim = 0.1;
        corner-radius = 10.0;
        detect-client-opacity = true;
        focus-exclude =
          [
            "fullscreen"
            "_NET_WM_STATE@[*]:a ^= '_NET_WM_STATE_MAXIMIZED'"
          ]
          ++ [
            "class_g='Xfwm4'"
            "class_g='Xfce4-panel'"
          ];
      }
      // # Fade
      {
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.1;
        fade-delta = 15;
        no-fading-openclose = false;
      }
      // # Blur
      {
        blur-method = "dual_kawase";
        blur-strength = 3;
        blur-background-exclude = shadowExclude;
      }
      // # Animation
      {
        animations = [
          {
            triggers = ["close" "hide"];
            preset = "disappear";
            scale = 0.4;
            opacity = {
              duration = 0.4;
              start = "window-raw-opacity-before";
              end = 0;
            };
            blur-opacity = "opacity";
            shadow-opacity = "opacity";
          }
          {
            triggers = ["open" "show"];
            opacity = {
              curve = "cubic-bezier(0.3,1.0,0.4,1)";
              duration = 0.4;
              start = 0;
              end = "window-raw-opacity";
            };
            blur-opacity = "opacity";
            shadow-opacity = "opacity";
            offset-x = "(1 - scale-x) / 2 * window-width";
            offset-y = "(1 - scale-y) / 2 * window-height";
            scale-x = {
              curve = "cubic-bezier(0.3,1.0,0.4,1)";
              duration = 0.4;
              start = 0;
              end = 1;
            };
            scale-y = "scale-x";
            shadow-scale-x = "scale-x";
            shadow-scale-y = "scale-y";
            shadow-offset-x = "offset-x";
            shadow-offset-y = "offset-y";
          }
          {
            triggers = ["geometry"];
            scale-x = {
              curve = "cubic-bezier(0.3,1.0,0.4,1)";
              duration = 0.4;
              start = "window-width-before / window-width";
              end = 1;
            };
            scale-y = {
              curve = "cubic-bezier(0.3,1.0,0.4,1)";
              duration = 0.4;
              start = "window-height-before / window-height";
              end = 1;
            };
            offset-x = {
              curve = "cubic-bezier(0.3,1.0,0.4,1)";
              duration = 0.4;
              start = "window-x-before - window-x";
              end = 0;
            };
            offset-y = {
              curve = "cubic-bezier(0.3,1.0,0.4,1)";
              duration = 0.4;
              start = "window-y-before - window-y";
              end = 0;
            };

            shadow-scale-x = "scale-x";
            shadow-scale-y = "scale-y";
            shadow-offset-x = "offset-x";
            shadow-offset-y = "offset-y";
          }
        ];
      };
  };

  # Theme Fixes
  gui.launcher.shadow = false;
  user.homeConfig = {
    gtk.gtk3.extraCss = lib.mkBefore "decoration { box-shadow: none; }";
    programs.firefox.profiles.default.settings."browser.tabs.inTitlebar" = 0;
  };
}
