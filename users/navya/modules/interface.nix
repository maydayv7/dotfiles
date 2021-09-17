# Generated via dconf2nix
{ lib, ... }:
let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings =
  {
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
      picture-uri = "file:///home/v7/.local/share/backgrounds/Futura.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = "uint32 0";
      lock-enabled = false;
      picture-options = "zoom";
      picture-uri = "file:///home/v7/.local/share/backgrounds/Futura.jpg";
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
  };
}
