{
  sys,
  lib,
  ...
}:
with lib.hm.gvariant;
let
  inherit (builtins) head;
  fonts = sys.fonts.fontconfig.defaultFonts;
in
{
  ## Dconf Keys ##
  # Generated via nix-community/dconf2nix
  # Use 'dconf watch /' to record changes
  dconf.settings = {
    # Panel
    "io/elementary/desktop/wingpanel".use-transparency = true;
    "io/elementary/desktop/wingpanel/sound".max-volume = 100.0;
    "io/elementary/desktop/wingpanel/power".show-percentage = true;
    "io/elementary/desktop/wingpanel/bluetooth".bluetooth-enabled = false;
    "io/elementary/switchboard/keyboard".first-launch = false;
    "io/elementary/wingpanel/keyboard" = {
      show-a11y = true;
      capslock = true;
      numlock = true;
    };

    # Desktop
    "io/elementary/desktop/agent-geoclue2".location-enabled = true;
    "io/elementary/settings-daemon/power".profile-plugged-in = "performance";
    "io/elementary/notifications/applications/gala-other" = {
      remember = true;
      sounds = true;
    };

    "org/gnome/desktop/session".idle-delay = mkUint32 900;
    "org/gnome/desktop/a11y/keyboard".togglekeys-enable = true;
    "org/gnome/desktop/datetime".automatic-timezone = true;
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      clock-show-weekday = true;
      cursor-size = 32;
      enable-animations = true;
      enable-hot-corners = true;
      gtk-enable-primary-paste = true;
      locate-pointer = true;
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/background" = rec {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://${sys.gui.wallpaper}";
      picture-uri-dark = picture-uri;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = false;
      event-sounds = true;
      theme-name = "elementary";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "fingers";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 0;
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

    "io/elementary/settings-daemon/housekeeping" = {
      cleanup-downloads-folder = false;
      cleanup-screenshots-folder = false;
      cleanup-temp-folder = true;
      cleanup-trash-folder = true;
      old-files-age = 7;
    };

    # Window Manager
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
      titlebar-font = "${head fonts.sansSerif} Bold 11";
    };

    "io/elementary/desktop/wm/behavior" = {
      hotcorner-bottomleft = "show-workspace-view";
      hotcorner-bottomright = "switch-to-workspace-next";
      hotcorner-topleft = "open-launcher";
      move-fullscreened-workspace = true;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      cancel-input-capture = [ "<Super><Shift>Escape" ];
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };

    # Dock
    "io/elementary/dock" = {
      autohide-mode = "overlapping-focus-window";
      icon-size = 48;
      launchers = [
        "gala-multitaskingview.desktop"
        "google-chrome.desktop"
        "io.elementary.mail.desktop"
        "io.elementary.terminal.desktop"
        "io.elementary.files.desktop"
        "io.elementary.code.desktop"
        "io.elementary.settings.desktop"
      ];
    };

    # Gestures
    "io/elementary/desktop/wm/gestures" = {
      three-finger-swipe-horizontal = "switch-to-workspace";
      four-finger-swipe-horizontal = "move-to-workspace";
      three-finger-swipe-up = "multitasking-view";
      four-finger-swipe-up = "toggle-maximized";
      four-finger-pinch = "zoom";
    };

    # Apps
    "io/elementary/files/preferences".singleclick-select = false;
    "org/gtk/settings/file-chooser".sort-directories-first = true;

    "desktop/ibus/panel/emoji".font = "${head fonts.emoji} 16";
    "desktop/ibus/panel" = {
      show-icon-on-systray = false;
      use-custom-font = true;
      custom-font = "${head fonts.sansSerif} 10";
    };

    "com/github/stsdc/monitor/settings" = {
      background-state = true;
      indicator-state = true;
      indicator-cpu-state = false;
      indicator-gpu-state = false;
      indicator-memory-state = true;
      indicator-network-download-state = false;
      indicator-network-upload-state = false;
      indicator-temperature-state = true;
    };

    "io/elementary/terminal/settings" = {
      audible-bell = false;
      follow-last-tab = "true";
      font = "${head fonts.monospace} Medium 13";
      natural-copy-paste = false;
      unsafe-paste-alert = true;
    };

    "io/elementary/code/saved-state".outline-visible = true;
    "io/elementary/code/settings" = {
      autosave = false;
      prefer-dark-style = true;
      show-mini-map = true;
      show-right-margin = true;
      strip-trailing-on-save = true;
      plugins-enabled = [
        "editorconfig"
        "word-completion"
        "brackets-completion"
        "preserve-indent"
        "detect-indent"
      ];
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
      default-search-engine = "Google";
      use-google-search-suggestions = true;
    };

    "com/github/hezral/clips" = {
      first-run = false;
      hide-on-startup = true;
      min-column-number = 3;
      persistent-mode = false;
      prefer-dark-style = true;
      protected-mode = true;
      quick-paste = true;
      shake-reveal = false;
      show-close-button = false;
      theme-optin = true;
    };

    # Keyboard Shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      begin-move = [ ];
      begin-resize = [ ];
      close = [
        "<Super>q"
        "<Alt>F4"
      ];
      cycle-group = [ ];
      cycle-group-backward = [ ];
      maximize = [ "" ];
      minimize = [ "<Super>Down" ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ "<Shift><Super>Left" ];
      move-to-monitor-right = [ "<Shift><Super>Right" ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ ];
      move-to-workspace-2 = [ "" ];
      move-to-workspace-3 = [ "" ];
      move-to-workspace-4 = [ "" ];
      move-to-workspace-5 = [ "" ];
      move-to-workspace-6 = [ "" ];
      move-to-workspace-7 = [ "" ];
      move-to-workspace-8 = [ "" ];
      move-to-workspace-9 = [ "" ];
      move-to-workspace-down = [ ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ "<Primary><Super>Left" ];
      move-to-workspace-right = [ "<Primary><Super>Right" ];
      move-to-workspace-up = [ ];
      show-desktop = [ "<Super>d" ];
      switch-applications = [ "<Alt>Tab" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" ];
      switch-group = [ "<Super>Tab" ];
      switch-group-backward = [ "<Shift><Super>Tab" ];
      switch-to-workspace-1 = [ "<Super>Home" ];
      switch-to-workspace-2 = [ "" ];
      switch-to-workspace-3 = [ "" ];
      switch-to-workspace-4 = [ "" ];
      switch-to-workspace-5 = [ "" ];
      switch-to-workspace-6 = [ "" ];
      switch-to-workspace-7 = [ "" ];
      switch-to-workspace-8 = [ "" ];
      switch-to-workspace-9 = [ "" ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-last = [ "<Super>End" ];
      switch-to-workspace-left = [ "<Super>Left" ];
      switch-to-workspace-right = [ "<Super>Right" ];
      switch-to-workspace-up = [ ];
      toggle-maximized = [ "<Super>Up" ];
      unmaximize = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      email = [ "<Super>e" ];
      home = [ "<Super>f" ];
      magnifier-zoom-in = [ "<Super>equal" ];
      magnifier-zoom-out = [ "<Super>minus" ];
      play = [ "F4" ];
      screenreader = [ ];
      screensaver = [ "<Super>l" ];
      terminal = [ "<Super>t" ];
      volume-down = [ "AudioLowerVolume" ];
      volume-mute = [ "" ];
      volume-up = [ "AudioRaiseVolume" ];
      www = [ "<Super>w" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };

    "io/elementary/desktop/wm/keybindings" = {
      area-screenshot = [ "Print" ];
      screenshot = [ "<Shift>Print" ];
      expose-windows = [ "" ];
      pip = [ "" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Task Manager";
      binding = "<Primary><Alt>Return";
      command = "com.github.stsdc.monitor";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Terminal";
      binding = "<Super>t";
      command = "io.elementary.terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Calculator";
      binding = "Calculator";
      command = "io.elementary.calculator";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Clipboard";
      binding = "<Super>v";
      command = "gtk-launch com.github.hezral.clips";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "Emoji Picker";
      binding = "<Super>comma";
      command = "emote";
    };
  };
}
