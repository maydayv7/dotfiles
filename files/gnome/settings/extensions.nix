{
  sys,
  lib,
  pkgs,
  files,
  ...
}: let
  inherit (builtins) filter hasAttr map;
  inherit (lib) foldr hm mapAttrs' mkForce nameValuePair optionals recursiveUpdate;
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
      {package = removable-drive-menu;}
      {package = x11-gestures;}
      {package = xlanguagetray;}
      {
        package = workspace-indicator;
        disable = true;
      }
      {
        package = latest.gpu-supergfxctl-switch;
        disable = !sys.services.supergfxd.enable;
      }
      {
        package = top-bar-organizer;
        settings = {
          center-box-order = ["dateMenu"];
          left-box-order = [
            "WorkspaceMenu"
            "activities"
            "guillotine"
            "guillotine@fopdoodle.net"
            "FocusButton"
            "OpenPositionButton"
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
          emoji-keybind = ["<Super><Shift>e"];
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
        package = pkgs.custom.paperwm;
        settings =
          {
            animation-time = 0.25;
            disable-topbar-styling = false;
            gesture-horizontal-fingers = 3;
            gesture-workspace-fingers = 4;
            horizontal-margin = 10;
            maximize-within-tiling = true;
            open-window-position = 0;
            open-window-position-option-up = true;
            overview-ensure-viewport-animation = 1;
            overview-min-windows-per-row = 4;
            restore-attach-modal-dialogs = "true";
            restore-edge-tiling = "false";
            restore-workspaces-only-on-primary = "true";
            selection-border-size = 5;
            show-focus-mode-icon = true;
            show-open-position-icon = true;
            show-window-position-bar = true;
            show-workspace-indicator = true;
            topbar-mouse-scroll-enable = true;
            use-default-background = true;
            vertical-margin = 5;
            vertical-margin-bottom = 5;
            window-gap = 15;
            winprops = [];
          }
          // mapAttrs' (name: value:
            nameValuePair "keybindings/${name}" value) {
            barf-out = [""];
            barf-out-active = ["<Shift><Super>b"];
            center-horizontally = ["<Super>c"];
            center-vertically = [""];
            close-window = ["<Super>q"];
            cycle-height = [""];
            cycle-height-backwards = [""];
            cycle-width = [""];
            cycle-width-backwards = [""];
            drift-left = ["<Super>semicolon"];
            drift-right = ["<Super>apostrophe"];
            live-alt-tab = ["<Alt>Tab"];
            live-alt-tab-backward = ["<Shift><Alt>Tab"];
            live-alt-tab-scratch = ["<Control><Super>grave"];
            live-alt-tab-scratch-backward = [""];
            move-down = ["<Shift><Super>Down"];
            move-down-workspace = ["<Shift><Super>greater"];
            move-left = ["<Shift><Super>Left"];
            move-monitor-above = [""];
            move-monitor-below = [""];
            move-monitor-left = ["<Shift><Super>braceleft"];
            move-monitor-right = ["<Shift><Super>braceright"];
            move-previous-workspace = [""];
            move-previous-workspace-backward = [""];
            move-right = ["<Shift><Super>Right"];
            move-space-monitor-above = [""];
            move-space-monitor-below = [""];
            move-space-monitor-left = [""];
            move-space-monitor-right = [""];
            move-up = ["<Shift><Super>Up"];
            move-up-workspace = ["<Shift><Super>comma"];
            new-window = ["<Super>n"];
            previous-workspace = ["<Super>Tab"];
            previous-workspace-backward = ["<Shift><Super>Tab"];
            resize-h-dec = ["<Shift><Super>underscore"];
            resize-w-inc = ["<Super>equal"];
            slurp-in = ["<Super>b"];
            swap-monitor-above = [""];
            swap-monitor-below = [""];
            swap-monitor-left = ["<Control><Super>bracketleft"];
            swap-monitor-right = ["<Control><Super>bracketright"];
            switch-down-workspace = ["<Super>period"];
            switch-first = [""];
            switch-last = [""];
            switch-left = ["<Super>Left"];
            switch-monitor-above = [""];
            switch-monitor-below = [""];
            switch-monitor-left = ["<Super>bracketleft"];
            switch-monitor-right = ["<Super>bracketright"];
            switch-next = [""];
            switch-previous = [""];
            switch-up = ["<Super>Up"];
            switch-up-workspace = ["<Super>comma"];
            take-window = ["<Alt>grave"];
            toggle-maximize-width = ["<Super>m"];
            toggle-scratch = ["<Super>grave"];
            toggle-scratch-layer = ["<Shift><Super>asciitilde"];
            toggle-scratch-window = [""];
            toggle-top-and-position-bar = [""];
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
          app-folder-order = 2;
          app-grid-active-preview = false;
          app-grid-animation = 4;
          app-grid-bg-blur-sigma = 40;
          app-grid-columns = 0;
          app-grid-content = 2;
          app-grid-folder-center = true;
          app-grid-folder-columns = 0;
          app-grid-folder-icon-grid = 2;
          app-grid-folder-icon-size = -1;
          app-grid-folder-rows = 0;
          app-grid-icon-size = -1;
          app-grid-incomplete-pages = false;
          app-grid-names = 0;
          app-grid-order = 1;
          app-grid-page-width-scale = 80;
          app-grid-performance = true;
          app-grid-rows = 0;
          app-grid-spacing = 12;
          center-app-grid = true;
          center-dash-to-ws = false;
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
          dash-show-windows-before-activation = 3;
          enable-page-shortcuts = false;
          favorites-notify = 1;
          highlighting-style = 1;
          hot-corner-action = 1;
          hot-corner-fullscreen = true;
          hot-corner-position = 3;
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
          overview-bg-brightness = 50;
          overview-esc-behavior = 0;
          overview-mode = 0;
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
          search-view-animation = 1;
          search-width-scale = 105;
          search-windows-icon-scroll = 1;
          search-windows-order = 1;
          sec-wst-position-adjust = 0;
          secondary-ws-preview-scale = 100;
          secondary-ws-preview-shift = false;
          secondary-ws-thumbnail-scale = 5;
          secondary-ws-thumbnails-position = 2;
          show-app-icon-position = 1;
          show-bg-in-overview = true;
          show-search-entry = false;
          show-ws-preview-bg = false;
          show-ws-switcher-bg = false;
          show-wst-labels = 1;
          show-wst-labels-on-hover = true;
          smooth-blur-transitions = true;
          startup-state = 2;
          swipe-tracker-module = false;
          win-attention-handler-module = true;
          win-preview-icon-size = 1;
          win-preview-mid-mouse-btn-action = 1;
          win-preview-sec-mouse-btn-action = 0;
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
          ws-max-spacing = 350;
          ws-preview-bg-radius = 30;
          ws-preview-scale = 100;
          ws-sw-popup-h-position = 50;
          ws-sw-popup-mode = 0;
          ws-sw-popup-v-position = 50;
          ws-switcher-ignore-last = false;
          ws-switcher-mode = 0;
          ws-switcher-wraparound = false;
          ws-thumbnail-scale = 10;
          ws-thumbnail-scale-appgrid = 15;
          ws-thumbnails-full = false;
          ws-thumbnails-position = 0;
          wst-position-adjust = 0;
        };
      }
    ]
    ++ optionals sys.gui.fancy [
      {
        package = panel-corners;
        settings.panel-corners = false;
      }
    ]);
in {
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

  home = {
    packages = [pkgs.dconf2nix] ++ builtins.map (ext: ext.package) extensions;
    file.".config/guillotine.json".source = files.gnome.menu; # Action Menu
  };
}
