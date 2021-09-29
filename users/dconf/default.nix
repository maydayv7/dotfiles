# Generated via dconf2nix
{ lib, ... }:
let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  # Dconf Keys
  dconf.settings =
  {
    "org/gnome/desktop/wm/keybindings" = {
      begin-move = [];
      begin-resize = [];
      cycle-group = [];
      cycle-group-backward = [];
      maximize = [];
      minimize = [ "<Super>Down" ];
      move-to-workspace-1 = [];
      move-to-workspace-last = [];
      move-to-workspace-left = [ "<Primary><Super>Left" ];
      move-to-workspace-right = [ "<Primary><Super>Right" ];
      panel-main-menu = [];
      panel-run-dialog = [ "<Super>F2" ];
      switch-group = [];
      switch-group-backward = [];
      switch-to-workspace-left = [ "<Super>Left" ];
      switch-to-workspace-right = [ "<Super>Right" ];
      toggle-maximized = [ "<Super>Up" ];
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
    };
    
    "org/gnome/settings-daemon/plugins/media-keys" = {
      area-screenshot = [ "Print" ];
      area-screenshot-clip = [];
      control-center = [ "<Super>i" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
      email = [ "<Super>e" ];
      home = [ "<Super>f" ];
      magnifier = [ "<Super>x" ];
      magnifier-zoom-in = [ "<Super>equal" ];
      magnifier-zoom-out = [ "<Super>minus" ];
      screencast = [ "<Alt>Print" ];
      screenreader = [];
      screenshot = [ "<Shift>Print" ];
      screenshot-clip = [];
      window-screenshot = [ "<Primary>Print" ];
      window-screenshot-clip = [];
      www = [ "<Super>w" ];
    };
    
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>Return";
      command = "gnome-system-monitor";
      name = "Task Manager";
    };
    
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>t";
      command = "gnome-terminal";
      name = "Terminal";
    };
  
  "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
      visual-bell = false;
    };
    
    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };
    
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      locate-pointer = true;
      monospace-font-name = "MesloLGS NF 10";
      show-battery-percentage = true;
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
    
    "org/gnome/desktop/a11y" = {
      always-show-universal-access-status = true;
    };
    
    "org/gnome/desktop/a11y/applications" = {
      screen-magnifier-enabled = false;
    };
    
    "org/gnome/desktop/a11y/magnifier" = {
      cross-hairs-clip = true;
      cross-hairs-color = "#15519a";
      cross-hairs-length = 1440;
      cross-hairs-opacity = 1.0;
      mouse-tracking = "proportional";
      show-cross-hairs = true;
    };
    
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
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
    };
    
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
    
    "org/gnome/Geary" = {
      ask-open-attachment = true;
      compose-as-html = true;
      formatting-toolbar-visible = false;
      migrated-config = true;
      optional-plugins = [ "email-templates" "sent-sound" "mail-merge" ];
      startup-notifications = true;
    };
    
    "org/gnome/epiphany" = {
      active-clear-data-items = 391;
      ask-for-default = false;
      default-search-engine = "Google";
      restore-session-policy = "crashed";
      use-google-search-suggestions = true;
    };
    
    "org/gnome/epiphany/web" = {
      default-zoom-level = 1.0;
      enable-mouse-gestures = true;
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
    
    "org/gnome/gnome-screenshot" = {
      delay = 0;
      include-pointer = true;
      last-save-directory = "file:///home/v7/Pictures/Screenshots";
    };
    
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/v7/.local/share/backgrounds/Firewatch.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = "uint32 0";
      lock-enabled = false;
      picture-options = "zoom";
      picture-uri = "file:///home/v7/.local/share/backgrounds/Firewatch.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    
    "org/gnome/shell" = {
      command-history = [ "rt" "r" ];
      disable-user-extensions = false;
      disabled-extensions = [ "workspace-indicator@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "compiz-windows-effect@hermes83.github.com" "compiz-alike-magic-lamp-effect@hermes83.github.com" "clipboard-indicator@tudmotu.com" "caffeine@patapon.info" "just-perfection-desktop@just-perfection" "appindicatorsupport@rgcjonas.gmail.com" "lockkeys@vaina.lt" "screenshotlocations.timur@linux.com" "sound-output-device-chooser@kgshank.net" "Vitals@CoreCoding.com" "custom-hot-corners-extended@G-dH.github.com" "color-picker@tuberry" "top-bar-organizer@julian.gse.jsts.xyz" "drive-menu@gnome-shell-extensions.gcampax.github.com" "x11gestures@joseexposito.github.io" "dash-to-panel@jderose9.github.com" ];
      favorite-apps = [ "google-chrome.desktop" "org.gnome.Geary.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Terminal.desktop" "org.gnome.gedit.desktop" "gnome-control-center.desktop" ];
    };
  
  "org/gnome/shell/extensions/caffeine" = {
      inhibit-apps = [ "teams.desktop" "startcenter.desktop" ];
      nightlight-control = "never";
      show-notifications = false;
      user-enabled = true;
    };
    
    "org/gnome/shell/extensions/clipboard-indicator" = {
      cache-size = 1051;
      clear-history = [];
      confirm-clear = false;
      history-size = 70;
      move-item-first = true;
      next-entry = [];
      prev-entry = [];
      strip-text = true;
      toggle-menu = [ "<Super>v" ];
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/misc" = {
      barrier-fallback = true;
      fullscreen-global = false;
      watch-corners = false;
      ws-switch-wrap = true;
      ws-switch-ignore-last = true;
      ws-switch-indicator = true;
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-left-0" = {
      action = "showApplications";
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-right-0" = {
      action = "showDesktopMon";
      ctrl = false;
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-0" = {
      action = "toggleOverview";
      fullscreen = true;
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-1" = {
      h-expand = true;
      v-expand = true;
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-right-0" = {
      action = "nextWorkspace";
      ctrl = false;
    };
    
    "org/gnome/shell/extensions/just-perfection" = {
      app-menu-icon = false;
      dash = false;
      hot-corner = false;
      workspace-switcher-size = 7;
    };
    
    "org/gnome/shell/extensions/lockkeys" = {
      style = "show-hide";
    };
    
    "org/gnome/shell/extensions/screenshotlocations" = {
      save-directory = "/home/v7/Pictures/Screenshots";
    };
    
    "org/gnome/shell/extensions/sound-output-device-chooser" = {
      expand-volume-menu = false;
      hide-on-single-device = true;
    };
    
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [ "_default_icon_" ];
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
      available-monitors = [ 0 ];
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
      panel-element-positions = ''{"0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"dateMenu","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'';
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
      trans-bg-color = "#282828";
      trans-dynamic-anim-target = 1.0;
      trans-dynamic-anim-time = 200;
      trans-dynamic-behavior = "MAXIMIZED_WINDOWS";
      trans-dynamic-distance = 0;
      trans-gradient-bottom-color = "#8ab4f8";
      trans-gradient-bottom-opacity = 5.0e-2;
      trans-panel-opacity = 0.0;
      trans-use-custom-bg = false;
      trans-use-custom-gradient = false;
      trans-use-custom-opacity = false;
      trans-use-dynamic-opacity = false;
      tray-padding = 1;
      tray-size = 0;
      window-preview-show-title = true;
      window-preview-size = 150;
      window-preview-title-position = "TOP";
    };
  };
}
