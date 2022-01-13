{ config, lib, ... }:
with lib.hm.gvariant;
let homeDir = config.home.homeDirectory;
in {
  ## Dconf Keys ##
  # Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
  dconf.settings = {
    # Keyboard Shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      begin-move = [ ];
      begin-resize = [ ];
      close = [ "<Super>q" "<Alt>F4" ];
      cycle-group = [ ];
      cycle-group-backward = [ ];
      maximize = [ "<Super>Up" ];
      minimize = [ "<Super>Down" ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ "<Shift><Super>Left" ];
      move-to-monitor-right = [ "<Shift><Super>Right" ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ ];
      move-to-workspace-down = [ ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ "<Primary><Super>Left" ];
      move-to-workspace-right = [ "<Primary><Super>Right" ];
      move-to-workspace-up = [ ];
      panel-main-menu = [ ];
      panel-run-dialog = [ "<Super>F2" ];
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-to-workspace-down = [ "<Primary><Super>Down" "<Primary><Super>j" ];
      switch-to-workspace-left = [ "<Super>Left" ];
      switch-to-workspace-right = [ "<Super>Right" ];
      switch-to-workspace-up = [ "<Primary><Super>Up" "<Primary><Super>k" ];
      toggle-maximized = [ "<Super>m" ];
      unmaximize = [ ];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ ];
      open-application-menu = [ ];
      toggle-message-tray = [ ];
      toggle-overview = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      area-screenshot = [ "Print" ];
      area-screenshot-clip = [ ];
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
      email = [ "<Super>e" ];
      home = [ "<Super>f" ];
      magnifier = [ "<Super>x" ];
      magnifier-zoom-in = [ "<Super>equal" ];
      magnifier-zoom-out = [ "<Super>minus" ];
      rotate-video-lock-static = [ ];
      screencast = [ "<Alt>Print" ];
      screenreader = [ ];
      screenshot = [ "<Shift>Print" ];
      screenshot-clip = [ ];
      screensaver = [ "<Super>l" ];
      terminal = [ "<Super>t" ];
      volume-down = [ "AudioLowerVolume" ];
      volume-up = [ "AudioRaiseVolume" ];
      window-screenshot = [ "<Primary>Print" ];
      window-screenshot-clip = [ ];
      www = [ "<Super>w" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
      {
        binding = "<Primary><Alt>Return";
        command = "gnome-system-monitor";
        name = "Task Manager";
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
      {
        binding = "<Super>t";
        command = "gnome-terminal";
        name = "Terminal";
      };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
      titlebar-font = "Product Sans Bold 11";
      visual-bell = false;
    };

    # Core Settings
    "org/gnome/desktop/a11y".always-show-universal-access-status = true;
    "org/gnome/desktop/a11y/applications".screen-magnifier-enabled = false;

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      document-font-name = "Product Sans 11";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Product Sans Medium, Medium 11";
      gtk-im-module = "gtk-im-context-simple";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
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
    "org/gnome/boxes".shared-folders =
      "[<{'uuid': <'5b825243-4232-4426-9d82-3df05e684e42'>, 'path': <'${homeDir}'>, 'name': <'v7'>}>]";

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

    "com/github/hugolabe/Wike" = {
      custom-font = true;
      dark-mode = true;
      font-family = "Product Sans";
    };

    "org/gnome/builder/editor" = {
      auto-hide-map = true;
      auto-save-timeout = 60;
      completion-n-rows = 7;
      draw-spaces = [ "tab" ];
      highlight-current-line = true;
      highlight-matching-brackets = true;
      overscroll = 7;
      show-map = false;
      style-scheme-name = "builder-dark";
    };

    "org/gnome/builder/terminal" = {
      limit-scrollback = false;
      scrollback-lines = "uint32 10000";
    };

    "org/gnome/gitlab/somas/Apostrophe" = {
      color-scheme = "dark";
      input-format = "gfm";
    };

    "org/gnome/terminal/legacy" = {
      default-show-menubar = true;
      new-tab-position = "next";
      schema-version = 3;
      theme-variant = "dark";
    };

    "org/gnome/terminal/legacy/profiles:" = {
      default = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
      list = [ "b1dcc9dd-5262-4d8d-a863-c897e6d979b9" ];
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" =
      {
        audible-bell = false;
        background-transparency-percent = 8;
        backspace-binding = "ascii-delete";
        cursor-blink-mode = "system";
        cursor-shape = "ibeam";
        default-size-columns = 100;
        default-size-rows = 30;
        delete-binding = "delete-sequence";
        exit-action = "close";
        login-shell = false;
        palette = [
          "rgb(23,20,33)"
          "rgb(192,28,40)"
          "rgb(38,162,105)"
          "rgb(162,115,76)"
          "rgb(18,72,139)"
          "rgb(163,71,186)"
          "rgb(42,161,179)"
          "rgb(208,207,204)"
          "rgb(94,92,100)"
          "rgb(246,97,81)"
          "rgb(51,209,122)"
          "rgb(233,173,12)"
          "rgb(42,123,222)"
          "rgb(192,97,203)"
          "rgb(51,199,222)"
          "rgb(255,255,255)"
        ];
        scrollback-lines = 70000;
        scrollback-unlimited = true;
        scrollbar-policy = "always";
        use-custom-command = false;
        use-system-font = true;
        use-theme-colors = true;
        use-transparent-background = true;
        visible-name = "Terminal";
      };

    "org/gnome/gedit/preferences/ui".show-tabs-mode = "auto";
    "org/gnome/gedit/preferences/editor" = {
      scheme = "tango-dark";
      wrap-last-split-mode = "word";
    };

    "org/gnome/gnome-screenshot" = {
      delay = 0;
      include-pointer = true;
      last-save-directory = "file://${homeDir}/Pictures/Screenshots";
    };

    # App Grid
    "org/gnome/shell" = {
      app-picker-layout =
        "[{'org.gnome.Contacts.desktop': <{'position': <0>}>, 'org.gnome.Weather.desktop': <{'position': <1>}>, 'org.gnome.clocks.desktop': <{'position': <2>}>, 'org.gnome.Maps.desktop': <{'position': <3>}>, 'org.gnome.gitlab.somas.Apostrophe.desktop': <{'position': <4>}>, 'org.gnome.Photos.desktop': <{'position': <5>}>, 'org.gnome.FileRoller.desktop': <{'position': <6>}>, 'org.gnome.Calculator.desktop': <{'position': <7>}>, 'org.gnome.DejaDup.desktop': <{'position': <8>}>, 'balena-etcher-electron.desktop': <{'position': <9>}>, 'simple-scan.desktop': <{'position': <10>}>, 'gnome-system-monitor.desktop': <{'position': <11>}>, 'bluej.desktop': <{'position': <12>}>, 'org.gnome.Boxes.desktop': <{'position': <13>}>, 'org.gnome.Builder.desktop': <{'position': <14>}>, 'org.gnome.Calendar.desktop': <{'position': <15>}>, 'org.gnome.Characters.desktop': <{'position': <16>}>, 'io.github.celluloid_player.Celluloid.desktop': <{'position': <17>}>, 'org.gnome.Screenshot.desktop': <{'position': <18>}>, 'org.gnome.Cheese.desktop': <{'position': <19>}>, 'org.gnome.font-viewer.desktop': <{'position': <20>}>, 'org.gnome.Connections.desktop': <{'position': <21>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <22>}>, 'org.gnome.Dictionary.desktop': <{'position': <23>}>}, {'discord.desktop': <{'position': <0>}>, 'org.gnome.DiskUtility.desktop': <{'position': <1>}>, 'org.gnome.Evince.desktop': <{'position': <2>}>, 'com.github.maoschanz.drawing.desktop': <{'position': <3>}>, 'org.gnome.Extensions.desktop': <{'position': <4>}>, 'firefox.desktop': <{'position': <5>}>, 'org.gnome.Fractal.desktop': <{'position': <6>}>, 'de.haeckerfelix.Fragments.desktop': <{'position': <7>}>, '4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff': <{'position': <8>}>, 'org.gabmus.giara.desktop': <{'position': <9>}>, 'gimp.desktop': <{'position': <10>}>, 'gparted.desktop': <{'position': <11>}>, 'org.gnome.gThumb.desktop': <{'position': <12>}>, 'fr.handbrake.ghb.desktop': <{'position': <13>}>, 'org.gnome.eog.desktop': <{'position': <14>}>, 'io.github.seadve.Kooha.desktop': <{'position': <15>}>, 'org.gnome.Lollypop.desktop': <{'position': <16>}>, 'net.lutris.Lutris.desktop': <{'position': <17>}>, 'com.bitstower.Markets.desktop': <{'position': <18>}>, 'megasync.desktop': <{'position': <19>}>, 'teams.desktop': <{'position': <20>}>, 'org.gnome.Notes.desktop': <{'position': <21>}>, 'a136187d-1d93-4d35-8423-082f15957be9': <{'position': <22>}>, 'org.gnome.PasswordSafe.desktop': <{'position': <23>}>}, {'org.gnome.seahorse.Application.desktop': <{'position': <0>}>, 'org.pitivi.Pitivi.desktop': <{'position': <1>}>, 'playonlinux.desktop': <{'position': <2>}>, 'org.gnome.Podcasts.desktop': <{'position': <3>}>, 'org.gnome.Polari.desktop': <{'position': <4>}>, 'de.haeckerfelix.Shortwave.desktop': <{'position': <5>}>, 'org.gnome.SoundRecorder.desktop': <{'position': <6>}>, 'org.gnome.Sysprof3.desktop': <{'position': <7>}>, 'transmission-gtk.desktop': <{'position': <8>}>, 'org.gnome.tweaks.desktop': <{'position': <9>}>, 'b79e9b82-2127-459b-9e82-11bd3be09d04': <{'position': <10>}>, 'org.gnome.Epiphany.desktop': <{'position': <11>}>, 'whatsapp-for-linux.desktop': <{'position': <12>}>, 'com.github.hugolabe.Wike.desktop': <{'position': <13>}>, 'winetricks.desktop': <{'position': <14>}>, 'Zoom.desktop': <{'position': <15>}>}]";
      command-history = [ "rt" "r" ];
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      disabled-extensions =
        [ "workspace-indicator@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "compiz-windows-effect@hermes83.github.com"
        "compiz-alike-magic-lamp-effect@hermes83.github.com"
        "clipboard-indicator@tudmotu.com"
        "caffeine@patapon.info"
        "just-perfection-desktop@just-perfection"
        "appindicatorsupport@rgcjonas.gmail.com"
        "lockkeys@vaina.lt"
        "screenshotlocations.timur@linux.com"
        "sound-output-device-chooser@kgshank.net"
        "Vitals@CoreCoding.com"
        "custom-hot-corners-extended@G-dH.github.com"
        "color-picker@tuberry"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "x11gestures@joseexposito.github.io"
        "dash-to-panel@jderose9.github.com"
        "flypie@schneegans.github.com"
        "color-picker@tuberry"
        "pop-shell@system76.com"
        "burn-my-windows@schneegans.github.com"
        "gTile@vibou"
        "desktop-cube@schneegans.github.com"
      ];
      favorite-apps = [
        "google-chrome.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.gedit.desktop"
        "gnome-control-center.desktop"
      ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "a136187d-1d93-4d35-8423-082f15957be9"
        "b79e9b82-2127-459b-9e82-11bd3be09d04"
        "4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff"
      ];
    };

    "org/gnome/desktop/app-folders/folders/4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff" =
      {
        apps = [
          "org.gnome.Chess.desktop"
          "org.gnome.Sudoku.desktop"
          "org.gnome.Mines.desktop"
          "org.gnome.Quadrapassel.desktop"
        ];
        name = "Games";
      };

    "org/gnome/desktop/app-folders/folders/a136187d-1d93-4d35-8423-082f15957be9" =
      {
        apps = [
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
        name = "Office";
      };

    "org/gnome/desktop/app-folders/folders/b79e9b82-2127-459b-9e82-11bd3be09d04" =
      {
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
        name = "Utilities";
        translate = false;
      };

    # Shell Extensions
    "org/gnome/shell/extensions/user-theme".name = "Adwaita";
    "org/gnome/shell/extensions/caffeine" = {
      inhibit-apps = [ "teams.desktop" "startcenter.desktop" ];
      nightlight-control = "never";
      show-notifications = false;
      user-enabled = true;
    };

    "org/gnome/shell/extensions/color-picker" = {
      color-picker-shortcut = [ "<Super>c" ];
      enable-shortcut = true;
      enable-systray = true;
      menu-size = "uint32 8";
      notify-style = "uint32 1";
      persistent-mode = true;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      cache-size = 1051;
      clear-history = [ ];
      confirm-clear = false;
      history-size = 70;
      move-item-first = true;
      next-entry = [ ];
      prev-entry = [ ];
      strip-text = true;
      toggle-menu = [ "<Super>v" ];
    };

    "org/gnome/shell/extensions/custom-hot-corners-extended/misc" = {
      ws-switch-wrap = true;
      ws-switch-ignore-last = true;
      ws-switch-indicator-mode = 1;
    };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-0".action =
      "toggle-overview";
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-left-0".action =
      "show-applications";

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-right-0" =
      {
        action = "show-desktop";
        ctrl = true;
      };

    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-right-0" =
      {
        action = "next-workspace";
        ctrl = true;
      };

    "org/gnome/shell/extensions/burn-my-windows" = {
      fire-color-1 = "rgba(0,110,255,0)";
      fire-color-2 = "rgba(30,111,180,0.24)";
      fire-color-3 = "rgba(38,181,255,0.54)";
      fire-color-4 = "rgba(34,162,255,0.84)";
      fire-color-5 = "rgb(97,189,255)";
      flame-movement-speed = -0.1;
      flame-scale = 1.5;
    };

    "org/gnome/shell/extensions/desktop-cube" = {
      active-workpace-opacity = 195;
      depth-separation = 25;
      horizontal-stretch = 100;
      inactive-workpace-opacity = 224;
      overview-transition-time = 0;
      unfold-to-desktop = false;
      workpace-separation = 25;
      workspace-transition-time = 250;
    };

    "org/gnome/shell/extensions/gtile" = {
      show-icon = false;
      target-presets-to-monitor-of-mouse = true;
      theme = "Default";
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
      workspace-background-corner-size = 58;
      workspace-switcher-size = 7;
    };

    "org/gnome/shell/extensions/lockkeys".style = "show-hide";
    "org/gnome/shell/extensions/screenshotlocations".save-directory =
      "${homeDir}/Pictures/Screenshots";

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
      animate-appicon-hover-animation-convexity =
        "{'RIPPLE': 2.2000000000000002, 'PLANK': 1.0, 'SIMPLE': 0.0}";
      animate-appicon-hover-animation-extent =
        "{'RIPPLE': 6, 'PLANK': 4, 'SIMPLE': 1}";
      animate-appicon-hover-animation-rotation =
        "{'SIMPLE': 7, 'RIPPLE': 10, 'PLANK': 0}";
      animate-appicon-hover-animation-travel =
        "{'SIMPLE': 0.16, 'RIPPLE': 0.27000000000000002, 'PLANK': 0.0}";
      animate-appicon-hover-animation-type = "RIPPLE";
      animate-appicon-hover-animation-zoom =
        "{'SIMPLE': 1.0900000000000001, 'RIPPLE': 1.1399999999999999, 'PLANK': 2.0}";
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
      trans-bg-color = "#282828";
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
      center-background-image =
        "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      center-background-image-hover =
        "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
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
      child-background-image =
        "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      child-background-image-hover =
        "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
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
      grandchild-background-image =
        "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
      grandchild-background-image-hover =
        "/run/current-system/sw/share/gnome-shell/extensions/flypie@schneegans.github.com/presets/assets/adwaita-dark.svg";
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
