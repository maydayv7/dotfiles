{files ? null, ...}: {
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  let
    inherit
      (builtins)
      filter
      genList
      hasAttr
      map
      toString
      ;

    inherit
      (lib)
      foldr
      getExe
      hm
      listToAttrs
      mkForce
      nameValuePair
      optionals
      recursiveUpdate
      ;

    inherit (osConfig.lib.stylix) colors;

    # Shell Extensions
    extensions = with pkgs.gnomeExtensions // hm.gvariant; (
      [
        {package = appindicator;}
        {package = arrange-windows;}
        {package = disconnect-wifi;}
        {package = display-configuration-switcher;}
        {package = gsconnect;}
        {package = guillotine;}
        {package = hide-minimized;}
        {package = media-progress;}
        {package = night-light-slider-updated;}
        {package = notification-counter;}
        {package = overview-hover;}
        {package = removable-drive-menu;}
        {package = screenshot-window-sizer;}
        {package = unmess;}
        {package = window-state-manager;}
        {
          package = workspace-indicator;
          disable = true;
        }
        {
          package = gpu-supergfxctl-switch;
          disable = !osConfig.services.supergfxd.enable;
        }
        {
          package = solaar-extension;
          disable = !osConfig.hardware.logitech.wireless.enableGraphical;
        }
        {
          package = syncthing-indicator;
          name = "syncthing";
          disable = !config.services.syncthing.enable;
          settings.auto-start = false;
        }
        {
          package = top-bar-organizer;
          settings = {
            center-box-order = ["dateMenu"];
            left-box-order = [
              "activities"
              "arrange-menu"
              "tilingshell@ferrarodomenico.com"
              "guillotine"
              "guillotine@fopdoodle.net"
              "appMenu"
            ];

            right-box-order = [
              "emoji-copy@felipeftn"
              "a11y"
              "aggregateMenu"
              "drive-menu"
              "copyous@boerdereinar.dev"
              "vitalsMenu"
              "dwellClick"
              "color-picker@tuberry"
              "gamemodeshellextension@trsnaqe.com"
              "lockkeys"
              "keyboard"
              "screenSharing"
              "screenRecording"
              "quickSettings"
            ];
          };
        }
        {package = app-name-indicator;}
        {
          package = status-area-horizontal-spacing;
          settings.hpadding = 4;
        }
        {
          package = autohide-battery;
          settings.hide-on = 80;
        }
        {
          package = color-picker;
          settings.enable-format = true;
        }
        {
          package = focus-follows-workspace;
          settings.move-cursor = true;
        }
        {
          package = fullscreen-avoider;
          settings = {
            move-hot-corners = true;
            move-notifications = true;
          };
        }
        {
          package = gamemode-shell-extension;
          name = "gamemodeshellextension";
          settings.show-icon-only-when-active = true;
        }
        {
          package = lock-keys;
          name = "lockkeys";
          settings.always-show-icon = false;
        }
        {
          package = user-themes;
          name = "user-theme";
          settings.name = mkForce "custom";
        }
        {
          package = bluetooth-battery-meter;
          name = "Bluetooth-Battery-Meter";
          settings = {
            disable-level-in-icon = true;
            enable-battery-indicator-text = false;
            enable-battery-level-icon = false;
            enable-battery-level-text = false;
            enable-multi-indicator-mode = false;
            enable-sony-device = true;
            enable-upower-level-icon = true;
            hide-bluetooth-indicator = 0;
            indicator-type = 1;
            level-indicator-color = 0;
            level-indicator-type = 0;
            popup-in-quick-settings = false;
            swap-icon-text = false;
          };
        }
        {
          package = brightness-control-using-ddcutil;
          disable = true;
          settings = {
            button-location = 1;
            ddcutil-binary-path = getExe pkgs.ddcutil;
            hide-system-indicator = true;
            increase-brightness-shortcut = ["<Shift>XF86MonBrightnessUp"];
            decrease-brightness-shortcut = ["<Shift>XF86MonBrightnessDown"];
          };
        }
        {
          package = caffeine;
          settings = {
            indicator-position = 0;
            nightlight-control = "never";
            show-indicator = "always";
            show-notifications = false;
            inhibit-apps = [
              "startcenter.desktop"
              "virt-manager.desktop"
            ];
          };
        }
        {
          package = copyous;
          settings = {
            auto-hide-search = false;
            clipboard-orientation = "horizontal";
            clipboard-position-horizontal = "fill";
            clipboard-position-vertical = "bottom";
            clipboard-history = "keep-all";
            clipboard-size = 700;
            disable-hljs-dialog = false;
            header-controls-visibility = "visible-on-hover";
            history-length = 250;
            open-clipboard-dialog-shortcut = ["<Super>v"];
            show-at-cursor = false;
            show-at-pointer = false;
            show-indicator = true;
            toggle-incognito-mode-shortcut = ["<Control><Super>v"];
            wiggle-indicator = true;
          };
        }
        {
          package = coverflow-alt-tab;
          name = "coverflowalttab";
          settings = {
            hide-panel = false;
            highlight-mouse-over = false;
            icon-style = "Classic";
            position = "Bottom";
            raise-mouse-over = true;
            switch-per-monitor = true;
            switcher-looping-method = "Flip Stack";
            switcher-style = "Coverflow";
          };
        }
        {
          package = emoji-copy;
          settings = {
            active-keybind = true;
            always-show = false;
            emoji-keybind = ["<Super><Shift>e"];
            paste-on-select = true;
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
          package = notification-configurator;
          settings = {
            notification-position = "center";
            block-list = "[]";
            app-themes = ''
              {"poweralertd":{"appNameColor":[0.9647058844566345,0.3803921639919281,0.3176470696926117,1],"timeColor":[0.6,0.6,0.607843137,1],"backgroundColor":[0.329411765,0.329411765,0.352941176,1],"titleColor":[0.992156863,0.992156863,0.992156863,1],"bodyColor":[0.992156863,0.992156863,0.992156863,1],"appNameFontSize":18,"timeFontSize":14,"titleFontSize":14,"bodyFontSize":18}}
            '';
          };
        }
        {
          package = shortcuts;
          settings = {
            maxcolumns = 3;
            shortcuts-file = files.gnome.shortcuts;
            shortcuts-toggle-overview = ["<Super>slash"];
            show-icon = false;
            use-custom-shortcuts = true;
            use-transparency = true;
            visibility = 55;
          };
        }
        {
          package = tiling-shell;
          name = "tilingshell";
          settings = {
            enable-blur-selected-tilepreview = false;
            enable-blur-snap-assistant = false;
            enable-snap-assist = false;
            enable-tiling-system = true;
            enable-tiling-system-windows-suggestions = true;
            enable-window-border = false;
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
          package = workspace-switcher-manager;
          settings = {
            active-show-win-title = false;
            active-show-ws-name = true;
            inactive-show-ws-name = true;
            modifiers-hide-popup = true;
            monitor = 0;
            popup-mode = 0;
            popup-opacity = 100;
            vertical = 5;
            ws-ignore-last = false;
            ws-wraparound = true;
          };
        }
        {
          package = wsp-windows-search-provider;
          name = "windows-search-provider";
          settings = {
            custom-prefixes = "`";
            results-order = 1;
            search-commands = false;
            search-method = 1;
          };
        }
        {
          package = ddterm;
          path = "com/github/amezin/ddterm";
          settings =
            {
              ddterm-activate-hotkey = ["<Super>space"];
              hide-window-on-esc = true;
              panel-icon-type = "none";
              shortcut-find = ["<Control>f"];
              shortcut-page-close = ["<Control>w"];
              shortcut-win-new-tab = ["<Control>t"];
              show-animation = "ease-in-sine";
              show-animation-duration = 0.2;
              hide-animation = "ease-out-sine";
              hide-animation-duration = 0.1;
              window-skip-taskbar = false;
            }
            // (listToAttrs (
              genList (
                n: let
                  num = toString (n + 1);
                in
                  nameValuePair "shortcut-switch-to-tab-${num}" ["<Control>${num}"]
              )
              9
            ));
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
            app-folder-remove-button = 0;
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
            app-grid-remember-page = true;
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
            hot-corner-fullscreen = false;
            hot-corner-position = 1;
            hot-corner-ripples = true;
            layout-module = true;
            message-tray-module = true;
            new-window-focus-fix = false;
            new-window-monitor-fix = false;
            notification-position = 1;
            osd-position = 2;
            osd-window-module = true;
            overlay-key-module = true;
            overlay-key-primary = 1;
            overlay-key-secondary = 1;
            overview-bg-blur-sigma = 50;
            overview-bg-brightness = 50;
            overview-esc-behavior = 1;
            overview-mode = 0;
            panel-module = true;
            panel-overview-style = 1;
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
            show-app-icon-position = 0;
            show-bg-in-overview = true;
            show-search-entry = false;
            show-ws-preview-bg = false;
            show-ws-switcher-bg = false;
            show-wst-labels = 1;
            show-wst-labels-on-hover = true;
            smooth-blur-transitions = true;
            startup-state = 2;
            swipe-tracker-module = true;
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
            ws-thumbnail-scale-appgrid = 20;
            ws-thumbnails-full = false;
            ws-thumbnails-position = 5;
            wst-position-adjust = 0;
          };
        }
      ]
      ++ optionals osConfig.gui.fancy [
        {
          package = rounded-window-corners-reborn;
          settings = {
            skip-libadwaita-app = false;
            skip-libhandy-app = false;
            border-width = -1;
            border-color = with colors;
              mkTuple [
                (mkDouble base0D-dec-r)
                (mkDouble base0D-dec-g)
                (mkDouble base0D-dec-b)
                1.0
              ];
            global-rounded-corner-settings = "{'padding': <{'left': 1, 'right': 1, 'top': 1, 'bottom': 1}>, 'keepRoundedCorners': <{'maximized': true, 'fullscreen': false}>, 'borderRadius': <uint32 12>, 'smoothing': <0.0>, 'enabled': <true>}";
            blacklist = ["com.github.amezin.ddterm"];
          };
        }
        {
          package = panel-corners;
          settings.panel-corners = true;
        }
        {
          package = transparent-window-moving;
          settings.window-opacity = 200;
        }
      ]
    );
  in {
    dconf.settings =
      {
        "org/gnome/shell" = let
          list = enabled:
            map (ext: ext.package.extensionUuid) (
              filter (ext:
                if enabled
                then (!(ext.disable or false))
                else (ext.disable or false))
              extensions
            );
        in {
          disable-user-extensions = false;
          disable-extension-version-validation = true;
          disabled-extensions = list false;
          enabled-extensions = list true;
        };
      }
      // foldr recursiveUpdate {} (
        map (
          ext:
            if (hasAttr "settings" ext)
            then
              (
                if (hasAttr "path" ext)
                then {"${ext.path}" = ext.settings;}
                else if (hasAttr "name" ext)
                then {"org/gnome/shell/extensions/${ext.name}" = ext.settings;}
                else {"org/gnome/shell/extensions/${ext.package.extensionPortalSlug}" = ext.settings;}
              )
            else {}
        )
        extensions
      );

    home = {
      packages = [pkgs.dconf2nix] ++ builtins.map (ext: ext.package) extensions;
      file.".config/guillotine.json".source = files.gnome.menu; # Action Menu
      persist.directories = [
        ".local/share/gnome-shell/extensions"

        # Clipboard
        ".cache/copyous@boerdereinar.dev"
        ".config/copyous@boerdereinar.dev"
        ".local/share/copyous@boerdereinar.dev"
      ];
    };
  }
)
