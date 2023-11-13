{
  config,
  sys,
  lib,
  files,
  ...
}:
with lib.hm.gvariant; let
  inherit (builtins) head elem;
  homeDir = config.home.homeDirectory;
  fonts = sys.fonts.fontconfig.defaultFonts;
  inherit (sys.gui) wallpaper;
in {
  # Home Directory
  home.file = {
    # Wallpapers
    ".local/share/backgrounds".source = files.wallpapers.path;

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
      switch-applications = ["<Alt>Tab"];
      switch-applications-backward = ["<Shift><Alt>Tab"];
      switch-group = ["<Super>Tab"];
      switch-group-backward = ["<Shift><Super>Tab"];
      switch-to-workspace-down = [];
      switch-to-workspace-left = ["<Super>Left"];
      switch-to-workspace-right = ["<Super>Right"];
      switch-to-workspace-up = [];
      toggle-maximized = ["F11"];
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
      www = ["<Super>grave"];
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
      command = "blackbox";
      name = "Terminal";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "${head fonts.sansSerif} Bold 11";
      visual-bell = false;
      num-workspaces = 4;
      workspace-names = ["Home" "School" "Work" "Play"];
    };

    # Core Settings
    "org/gnome/desktop/a11y".always-show-universal-access-status = true;
    "org/gnome/desktop/a11y/applications".screen-magnifier-enabled = false;

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
      document-font-name = "${head fonts.sansSerif} 11";
      enable-animations = true;
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "${head fonts.sansSerif} Medium, Medium 11";
      gtk-im-module = "gtk-im-context-simple";
      locate-pointer = true;
      monospace-font-name = "${head fonts.monospace} 11";
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
      night-light-temperature = mkUint32 3700;
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
      old-files-age = mkUint32 7;
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
      picture-uri = "file://${wallpaper}";
      picture-uri-dark = "file://${wallpaper}";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = mkUint32 0;
      lock-enabled = false;
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    # GTK+ Apps
    "org/gnome/desktop/calendar".show-weekdate = true;
    "ca/desrt/dconf-editor".show-warning = false;
    "org/gnome/shell/world-clocks".locations = "[<(uint32 2, <('Coordinated Universal Time (UTC)', '@UTC', false, @a(dd) [], @a(dd) [])>)>]";

    "org/gnome/desktop/search-providers" = {
      sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/Geary" = {
      ask-open-attachment = true;
      compose-as-html = true;
      formatting-toolbar-visible = false;
      migrated-config = true;
      optional-plugins = ["email-templates" "sent-sound" "mail-merge"];
      startup-notifications = true;
    };

    "org/gnome/epiphany/sync".sync-device-name = sys.networking.hostName;
    "org/gnome/epiphany/web" = {
      default-zoom-level = 1.0;
      enable-mouse-gestures = true;
    };

    "org/gnome/epiphany" = {
      active-clear-data-items = 391;
      ask-for-default = false;
      default-search-engine = "Google";
      restore-session-policy = "crashed";
      use-google-search-suggestions = true;
    };

    "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
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

    "com/raggesilver/BlackBox" = {
      font = "${head fonts.monospace} 11";
      headerbar-drag-area = true;
      notify-process-completion = true;
      opacity = mkUint32 90;
      remember-window-size = true;
      show-headerbar = true;
      show-menu-button = true;
      terminal-bell = false;
      pretty = true;
    };

    "org/gnome/TextEditor" = {
      highlight-current-line = true;
      indent-style = "tab";
      show-line-numbers = true;
      show-map = true;
      tab-width = mkUint32 4;
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

    "com/github/hugolabe/Wike" = {
      custom-font = true;
      dark-mode = true;
      font-family = head fonts.sansSerif;
    };

    # App Grid
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      disabled-extensions = ["workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "CoverflowAltTab@palatis.blogspot.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "emoji-copy@felipeftn"
        "forge@jmmaranan.com"
        "gestureImprovements@gestures"
        "gnome-ui-tune@itstime.tech"
        "guillotine@fopdoodle.net"
        "just-perfection-desktop@just-perfection"
        "lock-screen-message@advendradeswanta.gitlab.com"
        "lockkeys@vaina.lt"
        "pano@elhan.io"
        "quick-settings-avatar@d-go"
        "quick-settings-tweaks@qwreey"
        "rounded-window-corners@yilozt"
        "Shortcuts@kyle.aims.ac.za"
        "space-bar@luchrioh"
        "status-area-horizontal-spacing@mathematical.coffee.gmail.com"
        "timepp@zagortenay333"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "transparent-top-bar@ftpix.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
        "weatheroclock@CleoMenezesJr.github.io"
      ];
      favorite-apps = [
        "google-chrome.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Nautilus.desktop"
        "com.raggesilver.BlackBox.desktop"
        "org.gnome.TextEditor.desktop"
        "org.gnome.Settings.desktop"
      ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "1c3e59e4-a571-4ada-af1d-ed1ced384cfb"
        "4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff"
        "a136187d-1d93-4d35-8423-082f15957be9"
        "b79e9b82-2127-459b-9e82-11bd3be09d04"
        "cb1c8797-b52e-4df5-80d6-2c46e8f7ef22"
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
        "base.desktop"
        "calc.desktop"
        "Code.desktop"
        "draw.desktop"
        "impress.desktop"
        "math.desktop"
        "net.sourceforge.gscan2pdf.desktop"
        "onlyoffice-desktopeditors.desktop"
        "startcenter.desktop"
        "virt-manager.desktop"
        "writer.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/b79e9b82-2127-459b-9e82-11bd3be09d04" = {
      name = "Utilities";
      apps = [
        "cups.desktop"
        "nixos-manual.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Devhelp.desktop"
        "org.gnome.Logs.desktop"
        "org.gnome.Tour.desktop"
        "xterm.desktop"
        "yelp.desktop"
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

    "org/gnome/desktop/app-folders/folders/cb1c8797-b52e-4df5-80d6-2c46e8f7ef22" = {
      apps = [
        "waydroid.com.android.inputmethod.latin.desktop"
        "waydroid.org.lineageos.jelly.desktop"
        "waydroid.com.android.calculator2.desktop"
        "waydroid.org.lineageos.etar.desktop"
        "waydroid.com.android.camera2.desktop"
        "waydroid.com.android.deskclock.desktop"
        "waydroid.com.android.contacts.desktop"
        "waydroid.com.android.documentsui.desktop"
        "waydroid.com.android.gallery3d.desktop"
        "waydroid.com.android.vending.desktop"
        "waydroid.org.lineageos.eleven.desktop"
        "waydroid.org.lineageos.recorder.desktop"
        "waydroid.com.android.settings.desktop"
        "Waydroid.desktop"
      ];
      name = "Android";
      translate = false;
    };

    # Shell Extensions
    "org/gnome/shell/extensions/user-theme".name = "Adwaita";
    "org/gnome/shell/extensions/lock-screen-message".message = "Welcome, ${config.credentials.fullname}!";

    "com/ftpix/transparentbar".transparency = 0;
    "org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";
    "org/gnome/shell/extensions/gestureImprovements".allow-minimize-window = true;
    "org/gnome/shell/extensions/gnome-ui-tune".hide-search = false;
    "org/gnome/shell/extensions/lockkeys".style = "show-hide";
    "org/gnome/shell/extensions/status-area-horizontal-spacing".hpadding = 4;

    "org/gnome/shell/extensions/caffeine" = {
      indicator-position = 0;
      inhibit-apps = ["teams.desktop" "startcenter.desktop"];
      nightlight-control = "never";
      show-indicator = "always";
      show-notifications = false;
    };

    "org/gnome/shell/extensions/coverflowalttab" = {
      animation-time = 0.256;
      easing-function = "ease-in-sine";
      hide-panel = false;
      icon-has-shadow = false;
      icon-style = "Overlay";
    };

    "org/gnome/shell/extensions/emoji-copy" = {
      always-show = false;
      emoji-keybinding = ["<Super>period"];
      paste-on-select = true;
      use-keybinding = true;
    };

    "org/gnome/shell/extensions/forge" = {
      auto-split-enabled = true;
      focus-border-toggle = false;
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

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = true;
      aggregate-menu = true;
      animation = 4;
      app-menu-icon = false;
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
      play-audio-on-copy = false;
      send-notification-on-copy = false;
    };

    "org/gnome/shell/extensions/quick-settings-avatar" = {
      avatar-position = 1;
      avatar-realname = false;
      avatar-size = 56;
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      add-dnd-quick-toggle-enabled = false;
      add-unsafe-quick-toggle-enabled = false;
      datemenu-remove-notifications = false;
      media-control-compact-mode = true;
      media-control-enabled = true;
      notifications-enabled = false;
      volume-mixer-enabled = false;
      volume-mixer-position = "bottom";
    };

    "org/gnome/shell/extensions/rounded-window-corners" = {
      custom-rounded-corner-settings = "@a{sv} {}";
      focused-shadow = "{'vertical_offset': 4, 'horizontal_offset': 0, 'blur_offset': 28, 'spread_radius': 4, 'opacity': 60}";
      global-rounded-corner-settings = "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <true>, 'fullscreen': <false>}>, 'border_radius': <uint32 12>, 'smoothing': <uint32 0>, 'enabled': <true>}";
      settings-version = mkUint32 5;
      skip-libhandy-app = true;
      unfocused-shadow = "{'horizontal_offset': 0, 'vertical_offset': 2, 'blur_offset': 12, 'spread_radius': -1, 'opacity': 65}";
    };

    "org/gnome/shell/extensions/shortcuts" = {
      shortcuts-file = files.gnome.shortcuts;
      shortcuts-toggle-overview = ["<Super>slash"];
      use-custom-shortcuts = true;
      use-transparency = true;
      visibility = 50;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      scroll-wheel = "disabled";
      show-empty-workspaces = true;
      smart-workspace-names = true;
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
      center-box-order = ["dateMenu" "EmojisMenu"];
      left-box-order = [
        "Space Bar"
        "activities"
        "timepp"
        "guillotine"
        "guillotine@fopdoodle.net"
        "appMenu"
      ];
      right-box-order = [
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

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = ["_default_icon_"];
      show-battery = true;
      show-storage = false;
    };
  };
}
