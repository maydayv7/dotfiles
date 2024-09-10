{
  config,
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (builtins) filter hasAttr head map;
  inherit (lib) foldr hm mapAttrs' mkForce nameValuePair recursiveUpdate;
  homeDir = config.home.homeDirectory;
  font = head sys.fonts.fontconfig.defaultFonts.sansSerif;

  # Shell Extensions
  extensions = with pkgs.unstable.gnomeExtensions // pkgs.gnomeExtensions // hm.gvariant; [
    {package = appindicator;}
    {package = control-monitor-brightness-and-volume-with-ddcutil;}
    {package = gamemode-indicator-in-system-settings;}
    {package = guillotine;}
    {package = overview-hover;}
    {package = removable-drive-menu;}
    {package = smile-complementary-extension;}
    {package = transparent-top-bar;}
    {package = xlanguagetray;}
    {
      package = workspace-indicator;
      disable = true;
    }
    (
      if sys.services.supergfxd.enable
      then {package = gpu-supergfxctl-switch;}
      else {}
    )
    {
      package = top-bar-organizer;
      settings = {
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
    }
    {
      package = lock-keys;
      name = "lockkeys";
      settings.style = "show-hide";
    }
    {
      package = status-area-horizontal-spacing;
      settings.hpadding = 4;
    }
    {
      package = user-themes;
      name = "user-theme";
      settings.name = mkForce "custom";
    }
    {
      package = fullscreen-avoider;
      settings = {
        move-hot-corners = true;
        move-notifications = true;
      };
    }
    {
      package = window-title-is-back;
      settings = {
        colored-icon = true;
        show-title = false;
      };
    }
    {
      package = user-avatar-in-quick-settings;
      name = "quick-settings-avatar";
      settings = {
        avatar-position = 1;
        avatar-realname = false;
        avatar-size = 56;
      };
    }
    {
      package = vitals;
      settings = {
        hot-sensors = ["_default_icon_"];
        show-battery = true;
        show-storage = false;
      };
    }
    {
      package = alttab-mod;
      name = "altTab-mod";
      settings = {
        current-monitor-only = true;
        current-monitor-only-window = true;
        current-workspace-only = true;
        disable-hover-select = false;
        focus-on-select-window = true;
        remove-delay = true;
      };
    }
    {
      package = auto-activities;
      settings = {
        detect-minimized = true;
        hide-on-new-window = true;
        show-apps = false;
        skip-last-workspace = false;
        skip-taskbar = true;
      };
    }
    {
      package = caffeine;
      settings = {
        indicator-position = 0;
        inhibit-apps = ["startcenter.desktop"];
        nightlight-control = "never";
        show-indicator = "always";
        show-notifications = false;
      };
    }
    {
      package = shortcuts;
      settings = {
        maxcolumns = 3;
        shortcuts-file = files.gnome.shortcuts;
        shortcuts-toggle-overview = ["<Super>slash"];
        use-custom-shortcuts = true;
        use-transparency = true;
        visibility = 50;
      };
    }
    {
      package = pano;
      settings = {
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
    }
    {
      package = forge;
      settings =
        {
          auto-split-enabled = true;
          focus-border-toggle = true;
          stacked-tiling-mode-enabled = true;
          tabbed-tiling-mode-enabled = true;
          tiling-mode-enabled = false;
          window-gap-hidden-on-single = false;
        }
        // mapAttrs' (name: value:
          nameValuePair "keybindings/${name}" value) {
          con-split-horizontal = [];
          con-split-layout-toggle = [];
          con-split-vertical = [];
          con-stacked-layout-toggle = ["<Shift><Super>s"];
          con-tabbed-layout-toggle = ["<Shift><Super>t"];
          con-tabbed-showtab-decoration-toggle = [];
          focus-border-toggle = [];
          mod-mask-mouse-tile = "Super";
          prefs-open = [];
          prefs-tiling-toggle = ["<Super>y"];
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
          workspace-active-tile-toggle = ["<Shift><Super>y"];
        };
    }
    {
      package = window-gestures;
      name = "windowgestures";
      settings = {
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
    }
    {
      package = wsp-windows-search-provider;
      name = "windows-search-provider";
      settings = {
        custom-prefixes = "; `";
        results-order = 1;
        search-commands = false;
        search-method = 1;
      };
    }
    {
      package = vertical-workspaces;
      settings = {
        aaa-loading-profile = true;
        always-activate-selected-window = false;
        animation-speed-factor = 100;
        app-display-module = true;
        app-favorites-module = true;
        app-folder-order = 1;
        app-grid-active-preview = false;
        app-grid-animation = 4;
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
        app-grid-names = 0;
        app-grid-order = 1;
        app-grid-page-width-scale = 90;
        app-grid-performance = true;
        app-grid-rows = 0;
        app-grid-spacing = 12;
        center-app-grid = true;
        center-dash-to-ws = true;
        center-search = true;
        close-ws-button-mode = 2;
        dash-bg-color = 0;
        dash-bg-gs3-style = false;
        dash-bg-opacity = 50;
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
        enable-page-shortcuts = true;
        favorites-notify = 1;
        highlighting-style = 1;
        hot-corner-action = 1;
        hot-corner-fullscreen = false;
        hot-corner-position = 1;
        hot-corner-ripples = true;
        layout-module = true;
        message-tray-module = true;
        new-window-focus-fix = false;
        new-window-monitor-fix = false;
        notification-position = 1;
        osd-position = 6;
        osd-window-module = true;
        overlay-key-module = true;
        overlay-key-primary = 1;
        overlay-key-secondary = 1;
        overview-bg-blur-sigma = 50;
        overview-bg-brightness = 90;
        overview-esc-behavior = 0;
        overview-mode = 1;
        panel-module = true;
        panel-position = 0;
        panel-visibility = 0;
        recent-files-search-provider-module = false;
        running-dot-style = 1;
        search-bg-brightness = 50;
        search-controller-module = true;
        search-fuzzy = true;
        search-icon-size = 96;
        search-max-results-rows = 5;
        search-module = true;
        search-view-animation = 3;
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
        startup-state = 1;
        swipe-tracker-module = false;
        win-attention-handler-module = true;
        win-preview-icon-size = 1;
        win-preview-mid-mouse-btn-action = 0;
        win-preview-sec-mouse-btn-action = 1;
        win-preview-show-close-button = true;
        win-title-position = 0;
        window-attention-mode = 0;
        window-icon-click-action = 1;
        window-manager-module = true;
        window-preview-module = true;
        workspace-animation = 1;
        workspace-animation-module = true;
        workspace-module = true;
        workspace-switcher-animation = 1;
        workspace-switcher-popup-module = true;
        ws-max-spacing = 80;
        ws-preview-bg-radius = 30;
        ws-preview-scale = 100;
        ws-sw-popup-h-position = 50;
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
    }
  ];
in {
  home.packages = [pkgs.dconf2nix] ++ builtins.map (ext: ext.package) extensions;
  dconf.settings =
    {
      "org/gnome/shell" = let
        list = enabled:
          map (ext: ext.package.extensionUuid)
          (filter (
              ext:
                if enabled
                then (!(ext.disable or false))
                else (ext.disable or false)
            )
            extensions);
      in {
        disable-user-extensions = false;
        disable-extension-version-validation = true;
        disabled-extensions = list false;
        enabled-extensions = list true;
      };
    }
    // foldr recursiveUpdate {} (map
      (ext:
        if (hasAttr "settings" ext)
        then
          (
            if (hasAttr "name" ext)
            then {"org/gnome/shell/extensions/${ext.name}" = ext.settings;}
            else {"org/gnome/shell/extensions/${ext.package.extensionPortalSlug}" = ext.settings;}
          )
        else {})
      extensions);
}
