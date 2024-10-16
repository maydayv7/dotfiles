{
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (builtins) filter hasAttr map;
  inherit (lib) foldr hm mkForce optionals recursiveUpdate;
  latest = pkgs.unstable.gnomeExtensions;

  # Shell Extensions
  extensions = with pkgs.gnomeExtensions // hm.gvariant; ([
      {package = appindicator;}
      {package = control-monitor-brightness-and-volume-with-ddcutil;}
      {package = gamemode-indicator-in-system-settings;}
      {package = gsconnect;}
      {package = guillotine;}
      {package = hide-minimized;}
      {package = latest.invert-window-color;}
      {package = latest.media-progress;}
      {package = overview-hover;}
      {package = removable-drive-menu;}
      {package = unmess;}
      {package = window-state-manager;}
      {package = x11-gestures;}
      {package = xlanguagetray;}
      {
        package = workspace-indicator;
        disable = true;
      }
      (
        if sys.services.supergfxd.enable
        then {package = latest.gpu-supergfxctl-switch;}
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
            "tilingshell@ferrarodomenico.com"
            "a11y"
            "aggregateMenu"
            "drive-menu"
            "clipboardIndicator"
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
        package = latest.emoji-copy;
        settings = {
          active-keybind = true;
          always-show = false;
          paste-on-select = true;
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
        package = focus-changer;
        settings = {
          focus-down = ["<Super>s"];
          focus-left = ["<Super>a"];
          focus-right = ["<Super>d"];
          focus-up = ["<Super>w"];
        };
      }
      {
        package = vitals;
        settings = {
          hot-sensors = ["_default_icon_"];
          show-battery = true;
          show-storage = false;
          show-gpu = true;
          include-static-gpu-info = false;
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
        package = clipboard-indicator;
        settings = {
          cache-size = 20;
          clear-history = [];
          disable-down-arrow = true;
          history-size = 100;
          keep-selected-on-clear = true;
          move-item-first = true;
          next-entry = [];
          pinned-on-bottom = true;
          prev-entry = [];
          private-mode-binding = ["<Ctrl><Super>v"];
          toggle-menu = ["<Super>v"];
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
        package = pkgs.custom.gnome-tilingshell;
        name = "tilingshell";
        settings = {
          enable-blur-selected-tilepreview = false;
          enable-blur-snap-assistant = false;
          enable-snap-assist = false;
          enable-tiling-system = true;
          enable-window-border = true;
          override-window-menu = true;
          restore-window-original-size = true;
          tiling-system-activation-key = ["0"];
          top-edge-maximize = true;
          window-border-width = mkUint32 2;
          inner-gaps = mkUint32 5;
          outer-gaps = mkUint32 5;
          move-window-down = ["<Shift><Super>s"];
          move-window-left = ["<Shift><Super>a"];
          move-window-right = ["<Shift><Super>d"];
          move-window-up = ["<Shift><Super>w"];
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
          ws-thumbnail-scale = 10;
          ws-thumbnail-scale-appgrid = 15;
          ws-thumbnails-full = false;
          ws-thumbnails-position = 5;
          wst-position-adjust = 0;
        };
      }
    ]
    ++ optionals sys.gui.fancy [
      {package = latest.rounded-window-corners-reborn;}
      {package = transparent-top-bar;}
      {
        package = panel-corners;
        settings.panel-corners = false;
      }
    ]);
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
