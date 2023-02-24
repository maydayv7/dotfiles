{
  config,
  sys,
  lib,
  files,
  ...
}:
with lib.hm.gvariant; let
  homeDir = config.home.homeDirectory;
in {
  # Home Directory
  home.file = {
    # Wallpapers
    ".local/share/backgrounds".source = files.images.wallpapers;

    # GTK+ Bookmarks
    ".config/gtk-3.0/bookmarks".text = lib.mkBefore ''
      file://${homeDir}/Documents/TBD TBD
    '';
  };

  ## Dconf Keys ##
  # Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
  dconf.settings = {
    # Keyboard Shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      begin-move = [];
      begin-resize = [];
      close = ["<Super>q" "<Alt>F4"];
      cycle-group = [];
      cycle-group-backward = [];
      maximize = ["<Super>Up"];
      minimize = ["<Super>Down"];
      move-to-monitor-down = [];
      move-to-monitor-left = ["<Shift><Super>Left"];
      move-to-monitor-right = ["<Shift><Super>Right"];
      move-to-monitor-up = [];
      move-to-workspace-1 = [];
      move-to-workspace-down = [];
      move-to-workspace-last = [];
      move-to-workspace-left = ["<Primary><Super>Left"];
      move-to-workspace-right = ["<Primary><Super>Right"];
      move-to-workspace-up = [];
      panel-main-menu = [];
      panel-run-dialog = ["<Super>F2"];
      switch-group = [];
      switch-group-backward = [];
      switch-to-workspace-down = ["<Primary><Super>Down" "<Primary><Super>j"];
      switch-to-workspace-left = ["<Super>Left"];
      switch-to-workspace-right = ["<Super>Right"];
      switch-to-workspace-up = ["<Primary><Super>Up" "<Primary><Super>k"];
      toggle-maximized = ["<Super>m"];
      unmaximize = [];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [];
      open-application-menu = [];
      toggle-message-tray = [];
      toggle-overview = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      area-screenshot = ["Print"];
      area-screenshot-clip = [];
      control-center = ["<Super>i"];
      email = ["<Super>e"];
      home = ["<Super>f"];
      magnifier = ["<Super>x"];
      magnifier-zoom-in = ["<Super>equal"];
      magnifier-zoom-out = ["<Super>minus"];
      rotate-video-lock-static = [];
      screencast = ["<Alt>Print"];
      screenreader = [];
      screenshot = ["<Shift>Print"];
      screenshot-clip = [];
      screensaver = ["<Super>l"];
      terminal = ["<Super>t"];
      volume-down = ["AudioLowerVolume"];
      volume-up = ["AudioRaiseVolume"];
      window-screenshot = ["<Primary>Print"];
      window-screenshot-clip = [];
      www = ["<Super>w"];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>Return";
      command = "gnome-system-monitor";
      name = "Task Manager";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>t";
      command = "kgx";
      name = "Terminal";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "Product Sans Bold 11";
      visual-bell = false;
      num-workspaces = 4;
      workspace-names = ["Desktop" "School" "Work" "Play"];
    };

    # Core Settings
    "org/gnome/desktop/a11y".always-show-universal-access-status = true;
    "org/gnome/desktop/a11y/applications".screen-magnifier-enabled = false;

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
      document-font-name = "Product Sans 11";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Product Sans Medium, Medium 11";
      gtk-im-module = "gtk-im-context-simple";
      locate-pointer = true;
      monospace-font-name = "MesloLGS NF 10";
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1800;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 19.0;
      night-light-schedule-to = 7.0;
      night-light-temperature = "uint32 3700";
    };

    "org/gnome/desktop/a11y/magnifier" = {
      cross-hairs-clip = true;
      cross-hairs-color = "#15519a";
      cross-hairs-length = 1440;
      cross-hairs-opacity = 1.0;
      mouse-tracking = "proportional";
      show-cross-hairs = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-microphone = false;
      old-files-age = "uint32 7";
      remember-recent-files = false;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
      theme-name = "freedesktop";
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = "uint32 0";
      lock-enabled = false;
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    # GTK+ Apps
    "org/gnome/desktop/calendar".show-weekdate = true;
    "ca/desrt/dconf-editor".show-warning = false;
    "io/github/seadve/Kooha".video-format = "mp4";
    "org/gnome/boxes".shared-folders = "[<{'uuid': <'5b825243-4232-4426-9d82-3df05e684e42'>, 'path': <'${homeDir}'>, 'name': <'Home'>}>]";
    "org/gnome/shell/world-clocks".locations = "[<(uint32 2, <('Coordinated Universal Time (UTC)', '@UTC', false, @a(dd) [], @a(dd) [])>)>]";

    "org/gnome/Geary" = {
      ask-open-attachment = true;
      compose-as-html = true;
      formatting-toolbar-visible = false;
      migrated-config = true;
      optional-plugins = ["email-templates" "sent-sound" "mail-merge"];
      startup-notifications = true;
    };

    "org/gnome/epiphany" = {
      active-clear-data-items = 391;
      ask-for-default = false;
      default-search-engine = "Google";
      restore-session-policy = "crashed";
      use-google-search-suggestions = true;
    };

    "org/gnome/epiphany/sync".sync-device-name = sys.networking.hostName;
    "org/gnome/epiphany/web" = {
      default-zoom-level = 1.0;
      enable-mouse-gestures = true;
    };

    "org/gnome/nautilus/icon-view" = {
      captions = ["size" "date_modified" "none"];
      default-zoom-level = "medium";
    };

    "org/gnome/nautilus/preferences" = {
      click-policy = "single";
      default-folder-viewer = "icon-view";
      fts-enabled = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
      show-create-link = true;
      show-delete-permanently = true;
    };

    "com/github/hugolabe/Wike" = {
      custom-font = true;
      dark-mode = true;
      font-family = "Product Sans";
    };

    "org/gnome/builder/editor" = {
      auto-hide-map = true;
      auto-save-timeout = 60;
      completion-n-rows = 7;
      draw-spaces = ["tab"];
      highlight-current-line = true;
      highlight-matching-brackets = true;
      overscroll = 7;
      show-map = false;
      style-scheme-name = "builder-dark";
    };

    "org/gnome/gedit/preferences/ui".show-tabs-mode = "auto";
    "org/gnome/gedit/preferences/editor" = {
      scheme = "tango-dark";
      wrap-last-split-mode = "word";
      ensure-trailing-newline = false;
    };

    "org/gnome/gnome-screenshot" = {
      delay = 0;
      include-pointer = true;
      last-save-directory = "file://${homeDir}/Pictures/Screenshots";
    };

    # App Grid
    "org/gnome/shell" = {
      command-history = ["rt" "r"];
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      disabled-extensions = ["workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "avatar@pawel.swiszcz.com"
        "caffeine@patapon.info"
        "color-picker@tuberry"
        "compiz-alike-magic-lamp-effect@hermes83.github.com"
        "compiz-windows-effect@hermes83.github.com"
        "custom-hot-corners-extended@G-dH.github.com"
        "dash-to-panel@jderose9.github.com"
        "desktop-cube@schneegans.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "flypie@schneegans.github.com"
        "gTile@vibou"
        "just-perfection-desktop@just-perfection"
        "lock-screen-message@advendradeswanta.gitlab.com"
        "lockkeys@vaina.lt"
        "pano@elhan.io"
        "rounded-window-corners@yilozt"
        "timepp@zagortenay333"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "workspace-dry-names@benmoussatmouad.github.io"
        "x11gestures@joseexposito.github.io"
      ];
      favorite-apps = [
        "google-chrome.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.gedit.desktop"
        "org.gnome.Settings.desktop"
      ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "a136187d-1d93-4d35-8423-082f15957be9"
        "b79e9b82-2127-459b-9e82-11bd3be09d04"
        "4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff"
        "1c3e59e4-a571-4ada-af1d-ed1ced384cfb"
      ];
    };

    "org/gnome/desktop/app-folders/folders/4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff" = {
      name = "Games";
      apps = [
        "org.gnome.Chess.desktop"
        "org.gnome.Sudoku.desktop"
        "org.gnome.Mines.desktop"
        "org.gnome.Quadrapassel.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/a136187d-1d93-4d35-8423-082f15957be9" = {
      name = "Office";
      apps = [
        "Code.desktop"
        "startcenter.desktop"
        "writer.desktop"
        "impress.desktop"
        "draw.desktop"
        "base.desktop"
        "calc.desktop"
        "math.desktop"
        "onlyoffice-desktopeditors.desktop"
        "net.sourceforge.gscan2pdf.desktop"
        "virt-manager.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/b79e9b82-2127-459b-9e82-11bd3be09d04" = {
      name = "Utilities";
      apps = [
        "org.gnome.Logs.desktop"
        "org.gnome.Devhelp.desktop"
        "org.gnome.Tour.desktop"
        "cups.desktop"
        "nixos-manual.desktop"
        "yelp.desktop"
        "org.gnome.baobab.desktop"
        "xterm.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/1c3e59e4-a571-4ada-af1d-ed1ced384cfb" = {
      name = "Wine";
      apps = [
        "7zip.desktop"
        "Notepad++.desktop"
        "playonlinux.desktop"
        "net.lutris.Lutris.desktop"
      ];
    };

    # Shell Extensions
    "org/gnome/shell/extensions/workspace-dry-names".name-option = "countries";
    "org/gnome/shell/extensions/user-theme".name = "Adwaita";
    "org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";
    "org/gnome/shell/extensions/lock-screen-message".message = "Welcome, ${config.credentials.fullname}!";
    "org/gnome/shell/extensions/lockkeys".style = "show-hide";

    "org/gnome/shell/extensions/avatar" = {
      avatar-shadow = true;
      avatar-shadow-user-name = false;
      buttons-icon-size = 20;
      buttons-position = 50;
      name-style-dark = false;
      set-custom-panel-menu-width = 0;
      show-buttons = false;
      show-media-center = false;
      show-system-name = false;
      show-top-image = false;
    };

    "org/gnome/shell/extensions/caffeine" = {
      inhibit-apps = ["teams.desktop" "startcenter.desktop"];
      nightlight-control = "never";
      show-notifications = false;
      user-enabled = true;
    };

    "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
      friction = 6.0;
      mass = 50.0;
      resize-effect = true;
      speedup-factor-divider = 10.0;
      spring-k = 5.0;
    };

    "org/gnome/shell/extensions/color-picker" = {
      color-picker-shortcut = ["<Super>c"];
      enable-shortcut = true;
      enable-systray = true;
      menu-size = "uint32 8";
      notify-style = "uint32 1";
      persistent-mode = true;
    };

    "org/gnome/shell/extensions/custom-hot-corners-extended/misc" = {
      ws-switch-wrap = true;
      ws-switch-ignore-last = true;
      ws-switch-indicator-mode = 1;
    };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-0".action = "toggle-overview";
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-left-0".action = "show-applications";

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-right-0" = {
      action = "show-desktop";
      ctrl = true;
    };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-right-0" = {
      action = "next-workspace";
      ctrl = true;
    };

    "org/gnome/shell/extensions/desktop-cube" = {
      active-workpace-opacity = 195;
      depth-separation = 25;
      enable-desktop-edge-switch = false;
      horizontal-stretch = 100;
      inactive-workpace-opacity = 224;
      overview-transition-time = 0;
      unfold-to-desktop = false;
      workpace-separation = 25;
      workspace-transition-time = 250;
    };

    "org/gnome/shell/extensions/gtile" = {
      show-icon = true;
      target-presets-to-monitor-of-mouse = true;
      theme = "Minimal Dark";
      window-margin = 2;
      window-margin-fullscreen-enabled = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = true;
      aggregate-menu = true;
      animation = 4;
      app-menu-icon = false;
      dash = false;
      hot-corner = false;
      notification-banner-position = 2;
      show-prefs-intro = false;
      workspace-switcher-should-show = true;
      workspace-background-corner-size = 58;
      workspace-switcher-size = 7;
      workspace-wrap-around = true;
    };

    "org/gnome/shell/extensions/pano" = {
      database-location = "${homeDir}/.local/share/clipboard";
      global-shortcut = ["<Super>v"];
      history-length = 250;
      incognito-shortcut = ["<Ctrl><Super>v"];
    };

    "org/gnome/shell/extensions/rounded-window-corners" = {
      custom-rounded-corner-settings = "@a{sv} {}";
      focused-shadow = "{'vertical_offset': 4, 'horizontal_offset': 0, 'blur_offset': 28, 'spread_radius': 4, 'opacity': 60}";
      global-rounded-corner-settings = "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <true>, 'fullscreen': <false>}>, 'border_radius': <uint32 12>, 'smoothing': <uint32 0>, 'enabled': <true>}";
      settings-version = mkUint32 5;
      skip-libhandy-app = true;
      unfocused-shadow = "{'horizontal_offset': 0, 'vertical_offset': 2, 'blur_offset': 12, 'spread_radius': -1, 'opacity': 65}";
    };

    "org/gnome/shell/extensions/timepp" = {
      alarms-separate-menu = false;
      panel-item-position = "Left";
      pomodoro-panel-mode = "Dynamic";
      pomodoro-show-seconds = true;
      stopwatch-panel-mode = "Dynamic";
      timer-panel-mode = "Dynamic";
      timer-show-seconds = true;
      todo-panel-mode = "Icon";
      todo-separate-menu = true;
      unicon-mode = true;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = ["dateMenu"];
      left-box-order = ["workspace-name-indicator" "timepp" "appMenu" "activities"];
      right-box-order = [
        "aggregateMenu"
        "drive-menu"
        "color-picker@tuberry"
        "GTileStatusButton"
        "Caffeine"
        "pano@elhan.io"
        "vitalsMenu"
        "dwellClick"
        "lockkeys"
        "a11y"
        "keyboard"
        "screenSharing"
        "screenRecording"
      ];
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = ["_default_icon_"];
      show-battery = true;
      show-storage = false;
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = true;
      animate-appicon-hover-animation-convexity = "{'RIPPLE': 2.2000000000000002, 'PLANK': 1.0, 'SIMPLE': 0.0}";
      animate-appicon-hover-animation-extent = "{'RIPPLE': 6, 'PLANK': 4, 'SIMPLE': 1}";
      animate-appicon-hover-animation-rotation = "{'SIMPLE': 7, 'RIPPLE': 10, 'PLANK': 0}";
      animate-appicon-hover-animation-travel = "{'SIMPLE': 0.16, 'RIPPLE': 0.27000000000000002, 'PLANK': 0.0}";
      animate-appicon-hover-animation-type = "RIPPLE";
      animate-appicon-hover-animation-zoom = "{'SIMPLE': 1.0900000000000001, 'RIPPLE': 1.1399999999999999, 'PLANK': 2.0}";
      appicon-margin = 6;
      appicon-padding = 4;
      available-monitors = [0];
      desktop-line-custom-color = "rgb(138,180,248)";
      desktop-line-use-custom-color = false;
      dot-color-dominant = true;
      dot-color-override = false;
      dot-position = "BOTTOM";
      dot-size = 3;
      dot-style-focused = "CILIORA";
      dot-style-unfocused = "CILIORA";
      enter-peek-mode-timeout = 1100;
      focus-highlight = true;
      focus-highlight-color = "#eeeeee";
      focus-highlight-dominant = false;
      focus-highlight-opacity = 20;
      hide-overview-on-startup = false;
      hot-keys = true;
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = false;
      isolate-workspaces = true;
      leftbox-padding = -1;
      middle-click-action = "LAUNCH";
      overview-click-to-exit = false;
      panel-anchors = ''{"0":"MIDDLE"}'';
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'';
      panel-element-positions-monitors-sync = true;
      panel-lengths = ''{"0":100}'';
      panel-positions = ''{"0":"BOTTOM"}'';
      panel-sizes = ''{"0":48}'';
      scroll-panel-delay = 10;
      scroll-panel-show-ws-popup = true;
      secondarymenu-contains-appmenu = true;
      secondarymenu-contains-showdetails = true;
      shift-click-action = "QUIT";
      shift-middle-click-action = "RAISE";
      shortcut-previews = true;
      show-appmenu = true;
      show-apps-icon-file = "";
      show-showdesktop-hover = true;
      show-tooltip = true;
      showdesktop-button-width = 3;
      status-icon-padding = -1;
      stockgs-keep-dash = false;
      stockgs-keep-top-panel = false;
      stockgs-panelbtn-click-only = false;
      taskbar-locked = false;
      trans-bg-color = "#232323";
      trans-dynamic-anim-target = 1.0;
      trans-dynamic-anim-time = 200;
      trans-dynamic-behavior = "MAXIMIZED_WINDOWS";
      trans-dynamic-distance = 0;
      trans-gradient-bottom-color = "#8ab4f8";
      trans-gradient-bottom-opacity = 5.0e-2;
      trans-panel-opacity = 0.0;
      trans-use-custom-bg = true;
      trans-use-custom-gradient = false;
      trans-use-custom-opacity = false;
      trans-use-dynamic-opacity = false;
      tray-padding = 1;
      tray-size = 0;
      window-preview-show-title = true;
      window-preview-size = 150;
      window-preview-title-position = "TOP";
    };

    "org/gnome/shell/extensions/flypie" = {
      active-stack-child = "settings-page";
      background-color = "rgba(0, 0, 0, 0.26)";
      center-auto-color-luminance = 0.8;
      center-auto-color-luminance-hover = 0.8;
      center-auto-color-opacity = 0.0;
      center-auto-color-opacity-hover = 0.0;
      center-auto-color-saturation = 0.75;
      center-auto-color-saturation-hover = 0.75;
      center-background-image = "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      center-background-image-hover = "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      center-color-mode = "fixed";
      center-color-mode-hover = "fixed";
      center-fixed-color = "rgba(255,255,255,0)";
      center-fixed-color-hover = "rgba(255,255,255,0)";
      center-icon-crop = 0.8;
      center-icon-crop-hover = 0.8;
      center-icon-opacity = 0.17;
      center-icon-opacity-hover = 1.0;
      center-icon-scale = 0.7;
      center-icon-scale-hover = 0.7;
      center-size = 110.0;
      center-size-hover = 90.0;
      child-auto-color-luminance = 0.7;
      child-auto-color-luminance-hover = 0.8802816901408451;
      child-auto-color-opacity = 1.0;
      child-auto-color-opacity-hover = 1.0;
      child-auto-color-saturation = 0.9;
      child-auto-color-saturation-hover = 1.0;
      child-background-image = "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      child-background-image-hover = "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      child-color-mode = "fixed";
      child-color-mode-hover = "fixed";
      child-draw-above = false;
      child-fixed-color = "rgba(255,255,255,0)";
      child-fixed-color-hover = "rgba(255,255,255,0)";
      child-icon-crop = 0.8;
      child-icon-crop-hover = 0.8;
      child-icon-opacity = 1.0;
      child-icon-opacity-hover = 1.0;
      child-icon-scale = 0.7;
      child-icon-scale-hover = 0.7;
      child-offset = 106.0;
      child-offset-hover = 113.0;
      child-size = 59.0;
      child-size-hover = 77.0;
      easing-duration = 0.25;
      easing-mode = "ease-out";
      font = "Product Sans Medium, Medium 11";
      grandchild-background-image = "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      grandchild-background-image-hover = "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      grandchild-color-mode = "fixed";
      grandchild-color-mode-hover = "fixed";
      grandchild-draw-above = false;
      grandchild-fixed-color = "rgba(189,184,178,0)";
      grandchild-fixed-color-hover = "rgba(189,184,178,0)";
      grandchild-offset = 25.0;
      grandchild-offset-hover = 31.0;
      grandchild-size = 17.0;
      grandchild-size-hover = 27.0;
      menu-configuration = ''
        [{"name":"Navigation","icon":"application-menu","shortcut":"F9","centered":false,"id":0,"children":[{"name":"Sound","icon":"audio-speakers","children":[{"name":"Mute","icon":"discord-tray-muted","type":"Shortcut","data":"AudioMute","angle":-1},{"name":"Play / Pause","icon":"exaile-play","type":"Shortcut","data":"AudioPlay","angle":-1},{"name":"Next","icon":"go-next-symbolic","type":"Shortcut","data":"AudioNext","angle":90},{"name":"Previous","icon":"go-next-symbolic-rtl","type":"Shortcut","data":"AudioPrev","angle":270}],"type":"CustomMenu","data":{},"angle":-1},{"name":"Menu","type":"Command","icon":"gnome-menu","data":{"command":"gnome-extensions prefs flypie@schneegans.github.com"},"angle":-1},{"name":"Tasks","type":"Command","icon":"gnome-system-monitor","data":{"command":"gnome-system-monitor"},"angle":-1},{"name":"System","type":"System","icon":"system-log-out","angle":-1,"data":{}},{"name":"Previous","icon":"go-previous","type":"Shortcut","data":{"shortcut":"<Super>Left"},"angle":270},{"name":"Close","icon":"window-close","type":"Shortcut","data":"<Alt>F4","angle":-1},{"name":"Switcher","icon":"preferences-system-windows","type":"RunningApps","data":{"activeWorkspaceOnly":false,"appGrouping":true,"hoverPeeking":true,"nameRegex":""},"angle":-1},{"name":"Favorites","icon":"emblem-favorite","type":"Favorites","data":{},"angle":-1},{"name":"Maximize","icon":"view-fullscreen","type":"Shortcut","data":{"shortcut":"<Super>Up"},"angle":-1},{"name":"Next","icon":"go-next","type":"Shortcut","data":{"shortcut":"<Super>Right"},"angle":-1}],"type":"CustomMenu","data":{}}]'';
      preview-on-right-side = true;
      stashed-items = "[ ]";
      stats-abortions = mkUint32 38;
      stats-added-items = mkUint32 6;
      stats-click-selections-depth1 = mkUint32 15;
      stats-click-selections-depth2 = mkUint32 8;
      stats-click-selections-depth3 = mkUint32 7;
      stats-dbus-menus = mkUint32 24;
      stats-gesture-selections-depth1 = mkUint32 5;
      stats-gesture-selections-depth2 = mkUint32 3;
      stats-gesture-selections-depth3 = mkUint32 1;
      stats-preview-menus = mkUint32 19;
      stats-selections = mkUint32 39;
      stats-selections-1000ms-depth1 = mkUint32 6;
      stats-selections-2000ms-depth2 = mkUint32 1;
      stats-selections-3000ms-depth3 = mkUint32 1;
      stats-selections-750ms-depth1 = mkUint32 5;
      stats-settings-opened = mkUint32 13;
      stats-sponsors-viewed = mkUint32 1;
      stats-tutorial-menus = mkUint32 6;
      stats-unread-achievements = mkUint32 0;
      text-color = "rgb(222,222,222)";
      trace-color = "rgba(0,0,0,0.462838)";
      trace-min-length = 200.0;
      trace-thickness = 8.0;
      wedge-color = "rgba(0,0,0,0.129992)";
      wedge-color-hover = "rgba(0,0,0,0.0747331)";
      wedge-inner-radius = 43.0;
      wedge-separator-color = "rgba(255, 255, 255, 0.13)";
      wedge-separator-width = 1.0;
      wedge-width = 300.0;
    };
  };
}
