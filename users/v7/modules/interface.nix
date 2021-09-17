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
      app-picker-layout = "[{'teams.desktop': <{'position': <0>}>, 'Zoom.desktop': <{'position': <1>}>, 'bluej.desktop': <{'position': <2>}>, 'firefox.desktop': <{'position': <3>}>, 'aaa23e9c-3039-4fa7-8369-fd3cf42285c9': <{'position': <4>}>, 'io.github.celluloid_player.Celluloid.desktop': <{'position': <5>}>, 'org.gnome.Lollypop.desktop': <{'position': <6>}>, 'org.gnome.Cheese.desktop': <{'position': <7>}>, 'org.gnome.Boxes.desktop': <{'position': <8>}>, 'org.gnome.Connections.desktop': <{'position': <9>}>, 'org.gnome.Calculator.desktop': <{'position': <10>}>, 'org.gnome.Extensions.desktop': <{'position': <11>}>, 'org.gnome.tweaks.desktop': <{'position': <12>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <13>}>, 'org.gnome.DiskUtility.desktop': <{'position': <14>}>, 'htop.desktop': <{'position': <15>}>, 'gnome-system-monitor.desktop': <{'position': <16>}>}, {'org.gnome.FileRoller.desktop': <{'position': <0>}>, 'org.gnome.DejaDup.desktop': <{'position': <1>}>, 'org.gnome.Calendar.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Characters.desktop': <{'position': <4>}>, 'org.gnome.Contacts.desktop': <{'position': <5>}>, 'simple-scan.desktop': <{'position': <6>}>, 'org.gnome.Evince.desktop': <{'position': <7>}>, 'org.gnome.font-viewer.desktop': <{'position': <8>}>, 'org.gnome.eog.desktop': <{'position': <9>}>, 'org.gnome.Logs.desktop': <{'position': <10>}>, 'org.gnome.Maps.desktop': <{'position': <11>}>, 'org.gnome.seahorse.Application.desktop': <{'position': <12>}>, 'org.gnome.Photos.desktop': <{'position': <13>}>, 'org.gnome.Screenshot.desktop': <{'position': <14>}>, 'org.gnome.SoundRecorder.desktop': <{'position': <15>}>, 'org.gnome.Weather.desktop': <{'position': <16>}>, 'org.gnome.Epiphany.desktop': <{'position': <17>}>, 'e07cf156-fc1f-4daa-9263-c6b786c2f5d1': <{'position': <18>}>}, {'org.gnome.gitlab.somas.Apostrophe.desktop': <{'position': <0>}>, 'org.gnome.Dictionary.desktop': <{'position': <1>}>, 'discord.desktop': <{'position': <2>}>, 'com.github.maoschanz.drawing.desktop': <{'position': <3>}>, 'org.gnome.Fractal.desktop': <{'position': <4>}>, 'de.haeckerfelix.Fragments.desktop': <{'position': <5>}>, '5c11104f-f3ca-40aa-8ae1-50816314e1f6': <{'position': <6>}>, 'org.gabmus.giara.desktop': <{'position': <7>}>, 'gimp.desktop': <{'position': <8>}>, 'io.github.seadve.Kooha.desktop': <{'position': <9>}>, 'com.bitstower.Markets.desktop': <{'position': <10>}>, 'megasync.desktop': <{'position': <11>}>, 'org.gnome.Notes.desktop': <{'position': <12>}>, 'org.gnome.PasswordSafe.desktop': <{'position': <13>}>, 'org.gnome.Podcasts.desktop': <{'position': <14>}>, 'org.gnome.Polari.desktop': <{'position': <15>}>, 'de.haeckerfelix.Shortwave.desktop': <{'position': <16>}>, 'org.gnome.Todo.desktop': <{'position': <17>}>, 'com.github.hugolabe.Wike.desktop': <{'position': <18>}>}]";
      command-history = [ "rt" "r" ];
      disable-user-extensions = false;
      disabled-extensions = [ "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "timepp@zagortenay333" ];
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "compiz-windows-effect@hermes83.github.com" "compiz-alike-magic-lamp-effect@hermes83.github.com" "clipboard-indicator@tudmotu.com" "caffeine@patapon.info" "just-perfection-desktop@just-perfection" "appindicatorsupport@rgcjonas.gmail.com" "lockkeys@vaina.lt" "screenshotlocations.timur@linux.com" "sound-output-device-chooser@kgshank.net" "Vitals@CoreCoding.com" "custom-hot-corners-extended@G-dH.github.com" "color-picker@tuberry" "top-bar-organizer@julian.gse.jsts.xyz" "drive-menu@gnome-shell-extensions.gcampax.github.com" "x11gestures@joseexposito.github.io" "dash-to-panel@jderose9.github.com" ];
      favorite-apps = [ "google-chrome.desktop" "org.gnome.Geary.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Terminal.desktop" "org.gnome.gedit.desktop" "gnome-control-center.desktop" ];
    };
  };
}
