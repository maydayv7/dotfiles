{
  sys,
  lib,
  ...
}:
with lib.hm.gvariant; let
  inherit (builtins) head;
  fonts = sys.fonts.fontconfig.defaultFonts;
in {
  ## Dconf Keys ##
  # Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
  dconf.settings = {
    # Desktop
    "io/elementary/desktop/agent-geoclue2".location-enabled = true;
    "io/elementary/desktop/wingpanel".use-transparency = true;
    "io/elementary/desktop/wingpanel/datetime".clock-format = "24h";
    "io/elementary/desktop/wingpanel/sound".max-volume = 100.0;
    "io/elementary/desktop/wingpanel/power".show-percentage = true;
    "io/elementary/desktop/wingpanel/bluetooth".bluetooth-enabled = false;
    "io/elementary/switchboard/keyboard".first-launch = false;
    "io/elementary/files/preferences".singleclick-select = false;
    "io/elementary/settings-daemon/datetime".show-weeks = true;

    "org/gnome/desktop/session".idle-delay = mkUint32 900;
    "org/gnome/desktop/datetime".automatic-timezone = true;
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      cursor-size = 32;
      document-font-name = "${head fonts.sansSerif} 12";
      enable-animations = true;
      enable-hot-corners = true;
      font-name = "${head fonts.sansSerif} 12";
      gtk-enable-primary-paste = true;
      locate-pointer = true;
      monospace-font-name = "${head fonts.monospace} 13";
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/background" = rec {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://${sys.gui.wallpaper}";
      picture-uri-dark = picture-uri;
    };

    "io/elementary/notifications/applications/gala-other" = {
      remember = true;
      sounds = true;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = false;
      event-sounds = true;
      theme-name = "elementary";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1800;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "fingers";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
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
      old-files-age = 30;
    };

    # Window Manager
    "org/pantheon/desktop/gala/appearance".button-layout = ":minimize,maximize,close";
    "org/gnome/desktop/wm/preferences".titlebar-font = "${head fonts.sansSerif} Bold 11";

    "org/pantheon/desktop/gala/behavior" = {
      hotcorner-bottomleft = "show-workspace-view";
      hotcorner-bottomright = "switch-to-workspace-next";
      hotcorner-topleft = "open-launcher";
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
      cancel-input-capture = ["<Super><Shift>Escape"];
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    # Apps
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

    "org/gnome/epiphany" = {
      ask-for-default = false;
      default-search-engine = "Google";
      use-google-search-suggestions = true;
    };

    "io/elementary/terminal/settings" = {
      audible-bell = false;
      follow-last-tab = "true";
      font = "${head fonts.monospace} Medium 13";
      natural-copy-paste = false;
      unsafe-paste-alert = true;
    };

    "net/launchpad/plank/docks/dock1" = {
      current-workspace-only = true;
      icon-size = 60;
      pressure-reveal = true;
      theme = "default";
      zoom-enabled = true;
      zoom-percent = 120;
    };

    "io/elementary/code/saved-state".outline-visible = true;
    "io/elementary/code/settings" = {
      strip-trailing-on-save = true;
      show-mini-map = true;
      show-right-margin = true;
      prefer-dark-style = true;
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
      begin-move = [];
      begin-resize = [];
      close = ["<Super>q" "<Alt>F4"];
      cycle-group = [];
      cycle-group-backward = [];
      maximize = [""];
      minimize = ["<Super>Down"];
      move-to-monitor-down = [];
      move-to-monitor-left = ["<Shift><Super>Left"];
      move-to-monitor-right = ["<Shift><Super>Right"];
      move-to-monitor-up = [];
      move-to-workspace-1 = [];
      move-to-workspace-2 = [""];
      move-to-workspace-3 = [""];
      move-to-workspace-4 = [""];
      move-to-workspace-5 = [""];
      move-to-workspace-6 = [""];
      move-to-workspace-7 = [""];
      move-to-workspace-8 = [""];
      move-to-workspace-9 = [""];
      move-to-workspace-down = [];
      move-to-workspace-last = [];
      move-to-workspace-left = ["<Primary><Super>Left"];
      move-to-workspace-right = ["<Primary><Super>Right"];
      move-to-workspace-up = [];
      show-desktop = ["<Super>d"];
      switch-applications = ["<Alt>Tab"];
      switch-applications-backward = ["<Shift><Alt>Tab"];
      switch-group = ["<Super>Tab"];
      switch-group-backward = ["<Shift><Super>Tab"];
      switch-to-workspace-1 = ["<Super>Home"];
      switch-to-workspace-2 = [""];
      switch-to-workspace-3 = [""];
      switch-to-workspace-4 = [""];
      switch-to-workspace-5 = [""];
      switch-to-workspace-6 = [""];
      switch-to-workspace-7 = [""];
      switch-to-workspace-8 = [""];
      switch-to-workspace-9 = [""];
      switch-to-workspace-down = [];
      switch-to-workspace-last = ["<Super>End"];
      switch-to-workspace-left = ["<Super>Left"];
      switch-to-workspace-right = ["<Super>Right"];
      switch-to-workspace-up = [];
      toggle-maximized = ["<Super>Up"];
      unmaximize = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      email = ["<Super>e"];
      home = ["<Super>f"];
      magnifier-zoom-in = ["<Super>equal"];
      magnifier-zoom-out = ["<Super>minus"];
      play = ["F4"];
      screenreader = [];
      screensaver = ["<Super>l"];
      terminal = ["<Super>t"];
      volume-down = ["AudioLowerVolume"];
      volume-mute = [""];
      volume-up = ["AudioRaiseVolume"];
      www = ["<Super>w"];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };

    "org/pantheon/desktop/gala/keybindings" = {
      area-screenshot = ["Print"];
      expose-windows = [""];
      pip = [""];
      screenshot = ["<Shift>Print"];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>Return";
      command = "com.github.stsdc.monitor";
      name = "com.github.stsdc.monitor";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>t";
      command = "io.elementary.terminal";
      name = "io.elementary.terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "Calculator";
      command = "io.elementary.calculator";
      name = "io.elementary.calculator";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super>slash";
      command = "ulauncher-toggle";
      name = "ulauncher-toggle";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Super>v";
      command = "gtk-launch com.github.hezral.clips";
      name = "gtk-launch com.github.hezral.clips";
    };
  };
}
