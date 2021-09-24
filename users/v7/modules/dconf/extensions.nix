# Generated via dconf2nix
{ lib, ... }:
let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
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
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-left-0" = {
      action = "showApplications";
    };
    
    "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-bottom-right-0" = {
      action = "showDesktopMon";
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
