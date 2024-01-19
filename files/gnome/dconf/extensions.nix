{
  config,
  sys,
  lib,
  files,
  ...
}:
with lib.hm.gvariant; let
  homeDir = config.home.homeDirectory;
  font = builtins.head sys.fonts.fontconfig.defaultFonts.sansSerif;
in {
  # Shell Extensions
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      disabled-extensions = ["workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = [
        "alttab-mod@leleat-on-github"
        "appindicatorsupport@rgcjonas.gmail.com"
        "auto-activities@CleoMenezesJr.github.io"
        "caffeine@patapon.info"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "emoji-copy@felipeftn"
        "forge@jmmaranan.com"
        "fullscreen-avoider@noobsai.github.com"
        "gmind@tungstnballon.gitlab.com"
        "guillotine@fopdoodle.net"
        "langTray@a7medkhalaf"
        "lockkeys@vaina.lt"
        "openbar@neuromorph"
        "overviewhover@mattdavis90"
        "pano@elhan.io"
        "quick-settings-avatar@d-go"
        "Shortcuts@kyle.aims.ac.za"
        "status-area-horizontal-spacing@mathematical.coffee.gmail.com"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "vertical-workspaces@G-dH.github.com"
        "Vitals@CoreCoding.com"
        "windowgestures@extension.amarullz.com"
        "window-title-is-back@fthx"
      ];
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = ["dateMenu"];
      left-box-order = [
        "activities"
        "guillotine"
        "guillotine@fopdoodle.net"
        "appMenu"
      ];

      right-box-order = [
        "emoji-copy@felipeftn"
        "a11y"
        "aggregateMenu"
        "drive-menu"
        "pano@elhan.io"
        "vitalsMenu"
        "dwellClick"
        "lockkeys"
        "keyboard"
        "screenSharing"
        "screenRecording"
        "quickSettings"
      ];
    };

    "org/gnome/shell/extensions/lockkeys".style = "show-hide";
    "org/gnome/shell/extensions/status-area-horizontal-spacing".hpadding = 4;
    "org/gnome/shell/extensions/user-theme".name = lib.mkForce "custom";

    "org/gnome/shell/extensions/fullscreen-avoider" = {
      move-hot-corners = true;
      move-notifications = true;
    };

    "org/gnome/shell/extensions/window-title-is-back" = {
      colored-icon = true;
      show-title = false;
    };

    "org/gnome/shell/extensions/quick-settings-avatar" = {
      avatar-position = 1;
      avatar-realname = false;
      avatar-size = 56;
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = ["_default_icon_"];
      show-battery = true;
      show-storage = false;
    };

    "org/gnome/shell/extensions/altTab-mod" = {
      current-monitor-only = true;
      current-monitor-only-window = true;
      current-workspace-only = true;
      disable-hover-select = false;
      focus-on-select-window = true;
      remove-delay = true;
    };

    "org/gnome/shell/extensions/auto-activities" = {
      detect-minimized = true;
      hide-on-new-window = true;
      show-apps = false;
      skip-last-workspace = true;
      skip-taskbar = true;
    };

    "org/gnome/shell/extensions/caffeine" = {
      indicator-position = 0;
      inhibit-apps = ["teams.desktop" "startcenter.desktop"];
      nightlight-control = "never";
      show-indicator = "always";
      show-notifications = false;
    };

    "org/gnome/shell/extensions/emoji-copy" = {
      always-show = false;
      emoji-keybinding = ["<Super>period"];
      paste-on-select = true;
      use-keybinding = true;
    };

    "org/gnome/shell/extensions/shortcuts" = {
      maxcolumns = 3;
      shortcuts-file = files.gnome.shortcuts;
      shortcuts-toggle-overview = ["<Super>slash"];
      use-custom-shortcuts = true;
      use-transparency = true;
      visibility = 50;
    };

    "org/gnome/shell/extensions/openbar" = {
      balpha = 1.0;
      bartype = "Floating";
      bcolor = ["0.9647058844566345" "0.9607843160629272" "0.95686274766922"];
      bgalpha = 0.8;
      bgalpha2 = 0.0;
      bgcolor = ["0.1411764770746231" "0.1411764770746231" "0.1411764770746231"];
      bgcolor2 = ["0.10980392247438431" "0.4431372582912445" "0.8470588326454163"];
      bgpalette = false;
      bradius = 15.0;
      bwidth = 1.0;
      default-font = "${font} 12";
      fgcolor = ["1" "1" "1"];
      font = "${font} Bold 15";
      gradient = false;
      gradient-direction = "vertical";
      hcolor = ["0.46666666865348816" "0.4627451002597809" "0.48235294222831726"];
      heffect = false;
      height = 32.0;
      hpad = 0.0;
      margin = 1.0;
      mbalpha = 1.0;
      mbcolor = ["0.9647058844566345" "0.9607843160629272" "0.95686274766922"];
      mbgalpha = 0.8;
      mbgcolor = ["0.1411764770746231" "0.1411764770746231" "0.1411764770746231"];
      menustyle = true;
      mhcolor = ["0.3843137323856354" "0.6274510025978088" "0.9176470637321472"];
      mscolor = ["0.10980392247438431" "0.4431372582912445" "0.8470588326454163"];
      mshalpha = 0.25;
      mshcolor = ["0.8784313797950745" "0.8980392217636108" "0.9137254953384399"];
      neon = false;
      overview = true;
      reloadstyle = false;
      removestyle = false;
      shadow = false;
      shalpha = 1.0;
      vpad = 4.0;
    };

    "org/gnome/shell/extensions/pano" = {
      database-location = "${homeDir}/.local/share/clipboard";
      global-shortcut = ["<Super>v"];
      history-length = 250;
      incognito-shortcut = ["<Ctrl><Super>v"];
      play-audio-on-copy = false;
      send-notification-on-copy = false;
      window-position = mkUint32 2;
      item-date-font-family = font;
      item-date-font-size = 11;
      item-title-font-family = font;
      item-title-font-size = 20;
      search-bar-font-family = font;
      search-bar-font-size = 14;
    };

    "org/gnome/shell/extensions/forge" = {
      auto-split-enabled = true;
      focus-border-toggle = true;
      stacked-tiling-mode-enabled = true;
      tabbed-tiling-mode-enabled = true;
      tiling-mode-enabled = false;
      window-gap-hidden-on-single = false;
    };

    "org/gnome/shell/extensions/forge/keybindings" = {
      con-split-horizontal = [];
      con-split-layout-toggle = [];
      con-split-vertical = [];
      con-stacked-layout-toggle = ["<Shift><Super>s"];
      con-tabbed-layout-toggle = ["<Shift><Super>t"];
      con-tabbed-showtab-decoration-toggle = [];
      focus-border-toggle = [];
      mod-mask-mouse-tile = "Super";
      prefs-open = [];
      prefs-tiling-toggle = ["<Super>z"];
      window-focus-down = ["<Super>s"];
      window-focus-left = ["<Super>a"];
      window-focus-right = ["<Super>d"];
      window-focus-up = ["<Super>w"];
      window-gap-size-decrease = ["<Primary><Super>minus"];
      window-gap-size-increase = ["<Primary><Super>plus"];
      window-move-down = ["<Primary><Super>s"];
      window-move-left = ["<Primary><Super>a"];
      window-move-right = ["<Primary><Super>d"];
      window-move-up = ["<Primary><Super>w"];
      window-resize-bottom-decrease = ["<Alt><Primary><Super>Down"];
      window-resize-bottom-increase = ["<Alt><Super>Down"];
      window-resize-left-decrease = ["<Alt><Primary><Super>Left"];
      window-resize-left-increase = ["<Alt><Super>Left"];
      window-resize-right-decrease = ["<Alt><Primary><Super>Right"];
      window-resize-right-increase = ["<Alt><Super>Right"];
      window-resize-top-decrease = ["<Alt><Primary><Super>Up"];
      window-resize-top-increase = ["<Alt><Super>Up"];
      window-snap-center = ["<Super>c"];
      window-snap-one-third-left = [];
      window-snap-one-third-right = [];
      window-snap-two-third-left = [];
      window-snap-two-third-right = [];
      window-swap-down = ["<Shift><Super>s"];
      window-swap-last-active = [];
      window-swap-left = ["<Shift><Super>a"];
      window-swap-right = ["<Shift><Super>d"];
      window-swap-up = ["<Shift><Super>w"];
      window-toggle-always-float = [];
      window-toggle-float = ["<Shift><Super>F"];
      workspace-active-tile-toggle = ["<Shift><Super>z"];
    };

    "org/gnome/shell/extensions/windowgestures" = {
      fn-fullscreen = true;
      fn-maximized-snap = true;
      fn-move = true;
      fn-move-snap = true;
      fn-resize = true;
      pinch-enable = true;
      pinch3-in = 0;
      pinch3-out = 0;
      pinch4-in = 14;
      pinch4-out = 3;
      swipe3-down = 1;
      swipe4-updown = 22;
      taphold-move = true;
      three-finger = false;
      use-active-window = true;
    };

    "org/gnome/shell/extensions/vertical-workspaces" = {
      aaa-loading-profile = true;
      always-activate-selected-window = false;
      animation-speed-factor = 120;
      app-display-module = true;
      app-favorites-module = true;
      app-folder-order = 2;
      app-grid-active-preview = false;
      app-grid-animation = 3;
      app-grid-bg-blur-sigma = 40;
      app-grid-columns = 0;
      app-grid-content = 4;
      app-grid-folder-center = true;
      app-grid-folder-columns = 0;
      app-grid-folder-icon-grid = 2;
      app-grid-folder-icon-size = -1;
      app-grid-folder-rows = 0;
      app-grid-icon-size = -1;
      app-grid-incomplete-pages = false;
      app-grid-names = 1;
      app-grid-order = 1;
      app-grid-page-width-scale = 90;
      app-grid-performance = true;
      app-grid-rows = 0;
      app-grid-spacing = 12;
      center-app-grid = true;
      center-search = true;
      close-ws-button-mode = 2;
      dash-bg-color = 0;
      dash-bg-gs3-style = false;
      dash-bg-opacity = 35;
      dash-bg-radius = 0;
      dash-icon-scroll = 1;
      dash-isolate-workspaces = true;
      dash-max-icon-size = 64;
      dash-module = true;
      dash-position = 2;
      dash-position-adjust = 0;
      dash-show-extensions-icon = 0;
      dash-show-recent-files-icon = 0;
      dash-show-windows-before-activation = 1;
      dash-show-windows-icon = 2;
      enable-page-shortcuts = false;
      extensions-search-provider-module = true;
      favorites-notify = 1;
      hot-corner-action = 1;
      hot-corner-fullscreen = false;
      hot-corner-position = 1;
      hot-corner-ripples = true;
      layout-module = true;
      message-tray-module = true;
      new-window-focus-fix = false;
      notification-position = 2;
      osd-position = 7;
      osd-window-module = true;
      overlay-key-module = true;
      overlay-key-primary = 1;
      overlay-key-secondary = 1;
      overview-bg-blur-sigma = 50;
      overview-bg-brightness = 50;
      overview-esc-behavior = 1;
      overview-mode = 1;
      panel-module = true;
      panel-position = 0;
      panel-visibility = 0;
      recent-files-search-provider-module = false;
      running-dot-style = 1;
      search-bg-brightness = 30;
      search-controller-module = true;
      search-fuzzy = true;
      search-icon-size = 96;
      search-max-results-rows = 5;
      search-module = true;
      search-view-animation = 5;
      search-width-scale = 120;
      search-windows-icon-scroll = 1;
      search-windows-order = 1;
      sec-wst-position-adjust = 0;
      secondary-ws-preview-scale = 100;
      secondary-ws-preview-shift = false;
      secondary-ws-thumbnail-scale = 5;
      secondary-ws-thumbnails-position = 2;
      show-app-icon-position = 0;
      show-bg-in-overview = true;
      show-search-entry = true;
      show-ws-preview-bg = false;
      show-ws-switcher-bg = false;
      show-wst-labels = 2;
      show-wst-labels-on-hover = true;
      smooth-blur-transitions = true;
      startup-state = 2;
      swipe-tracker-module = false;
      win-attention-handler-module = true;
      win-preview-icon-size = 0;
      win-preview-mid-mouse-btn-action = 3;
      win-preview-sec-mouse-btn-action = 1;
      win-preview-show-close-button = true;
      win-title-position = 0;
      window-attention-mode = 0;
      window-icon-click-action = 1;
      window-manager-module = true;
      window-preview-module = true;
      window-search-provider-module = true;
      window-thumbnail-module = true;
      window-thumbnail-scale = 20;
      workspace-animation = 1;
      workspace-animation-module = true;
      workspace-module = true;
      workspace-switcher-animation = 1;
      workspace-switcher-popup-module = true;
      ws-max-spacing = 80;
      ws-preview-bg-radius = 30;
      ws-preview-scale = 100;
      ws-sw-popup-h-position = 44;
      ws-sw-popup-mode = 0;
      ws-sw-popup-v-position = 95;
      ws-switcher-ignore-last = false;
      ws-switcher-mode = 0;
      ws-switcher-wraparound = true;
      ws-thumbnail-scale = 8;
      ws-thumbnail-scale-appgrid = 13;
      ws-thumbnails-full = false;
      ws-thumbnails-position = 5;
      wst-position-adjust = 0;
    };
  };
}
