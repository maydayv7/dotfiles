{
  sys,
  lib,
  util,
  ...
}:
with lib.hm.gvariant; let
  fonts = sys.fonts.fontconfig.defaultFonts;
in {
  imports = util.map.modules.list ./.;

  ## Dconf Keys ##
  # Generated via gvolpe/dconf2nix
  # Use 'dconf watch /' to record changes
  dconf.settings = {
    # Keyboard Shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      always-on-top = ["<Super>p"];
      begin-move = [];
      begin-resize = [];
      close = ["<Alt>F4"];
      cycle-group = [];
      cycle-group-backward = [];
      maximize = [""];
      minimize = ["<Super>h"];
      move-to-center = [""];
      move-to-monitor-down = [];
      move-to-monitor-left = [""];
      move-to-monitor-right = [""];
      move-to-monitor-up = [];
      move-to-workspace-1 = [];
      move-to-workspace-down = [];
      move-to-workspace-last = [];
      move-to-workspace-left = [""];
      move-to-workspace-right = [""];
      move-to-workspace-up = [];
      panel-main-menu = [];
      panel-run-dialog = ["<Super>F2"];
      switch-applications = [""];
      switch-applications-backward = [""];
      switch-group = [""];
      switch-group-backward = [""];
      switch-to-workspace-down = [];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
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
      switch-to-application-1 = ["<Super>1"];
      switch-to-application-2 = ["<Super>2"];
      switch-to-application-3 = ["<Super>3"];
      switch-to-application-4 = ["<Super>4"];
      switch-to-application-5 = ["<Super>5"];
      switch-to-application-6 = ["<Super>6"];
      switch-to-application-7 = ["<Super>7"];
      switch-to-application-8 = ["<Super>8"];
      switch-to-application-9 = ["<Super>9"];
      toggle-application-view = [];
      toggle-message-tray = ["<Super><Shift>n"];
      toggle-overview = [];
      toggle-quick-settings = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      area-screenshot = ["Print"];
      area-screenshot-clip = [];
      control-center = [""];
      email = ["<Super>e"];
      home = ["<Super>f"];
      magnifier = ["<Super>x"];
      magnifier-zoom-in = ["<Super><Primary>equal"];
      magnifier-zoom-out = ["<Super><Primary>minus"];
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
      binding = "<Super>Return";
      command = "missioncenter";
      name = "Task Manager";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>t";
      command = "blackbox";
      name = "Terminal";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      focus-mode = "click";
      titlebar-font = "${builtins.head fonts.sansSerif} Bold 11";
      visual-bell = false;
    };

    # Core Settings
    "org/gnome/desktop/a11y".always-show-universal-access-status = true;
    "org/gnome/desktop/a11y/applications".screen-magnifier-enabled = false;

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = false;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
      experimental-features = ["scale-monitor-framebuffer" "x11-randr-fractional-scaling"];
    };

    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      enable-animations = true;
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "gtk-im-context-simple";
      locate-pointer = true;
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
      theme-name = "__custom";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = mkUint32 0;
      lock-enabled = false;
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
  };
}
