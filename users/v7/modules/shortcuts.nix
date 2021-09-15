# Generated via dconf2nix
{ lib, ... }:
let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
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
  };
}
