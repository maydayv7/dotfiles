{
  sys,
  lib,
  ...
}:
with lib.hm.gvariant; let
  inherit (builtins) head;
  fonts = sys.fonts.fontconfig.defaultFonts;
in {
  dconf.settings = {
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
        "com.usebottles.bottles.desktop"
        "Notepad++.desktop"
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
  };
}
