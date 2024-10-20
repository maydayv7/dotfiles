{
  lib,
  pkgs,
  ...
}: {
  ## Picom Compositor Configuration ##
  services.picom = rec {
    enable = true;

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

    # Behaviour
    fade = true;
    settings =
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
      //
      # Blur
      {
        blur-method = "dual_kawase";
        blur-strength = 3;
        blur-background-exclude = shadowExclude;
      }
      //
      # Animations
      {
        animations = true;
        animation-for-open-window = "zoom";
        animation-for-unmap-window = "zoom";
        animation-for-transient-window = "slide-up";
        animation-stiffness-in-tag = 150;
        animation-stiffness-tag-change = 90.0;
        animation-window-mass = 0.2;
        animation-dampening = 15;
        animation-clamping = true;
        animation-for-prev-tag = "minimize";
        enable-fading-prev-tag = true;
        animation-for-next-tag = "slide-in-center";
        enable-fading-next-tag = true;
      };

    package = pkgs.picom.overrideAttrs (old: {
      version = "11a";
      src = pkgs.fetchFromGitHub {
        owner = "FT-Labs";
        repo = "picom";
        rev = "fe5b416ed6f43c31418d21dde7a9f20c12d7dfb0";
        sha256 = "sha256-jouBx8fqoy/psD/P9dX3Q4/D4IWsLSxA210CKcBbh4I=";
      };
    });
  };

  # Theme Fixes
  gui.launcher.shadow = false;
  user.homeConfig = {
    gtk.gtk3.extraCss = lib.mkBefore "decoration { box-shadow: none; }";
    programs.firefox.profiles.default.settings."browser.tabs.inTitlebar" = 0;
  };
}
