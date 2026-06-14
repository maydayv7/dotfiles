_: {
  lib,
  osConfig ? null,
  ...
}:
lib.mkIf (osConfig != null) (
  with lib.hm.gvariant; let
    inherit (builtins) head;
    fonts = osConfig.fonts.fontconfig.defaultFonts;
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

      "org/gnome/epiphany/sync".sync-device-name = osConfig.networking.hostName;
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
        captions = [
          "size"
          "date_modified"
          "none"
        ];
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

      "org/gnome/TextEditor" = {
        highlight-current-line = true;
        indent-style = "tab";
        show-line-numbers = true;
        show-map = false;
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
          "brave-browser.desktop"
          "thunderbird.desktop"
          "org.gnome.Nautilus.desktop"
          "com.mitchellh.ghostty.desktop"
          "org.gnome.TextEditor.desktop"
          "org.gnome.Settings.desktop"
        ];
      };

      "org/gnome/desktop/app-folders" = {
        folder-children = [
          "1c3e59e4-a571-4ada-af1d-ed1ced384cfb"
          "4bfbecbd-804e-4359-b1c2-00daef4c009e"
          "4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff"
          "a136187d-1d93-4d35-8423-082f15957be9"
          "b79e9b82-2127-459b-9e82-11bd3be09d04"
          "cb1c8797-b52e-4df5-80d6-2c46e8f7ef22"
          "e57a32e8-8e5d-4808-aad7-b1f9152d01ee"
          "3ef67acf-9b33-4087-9a9b-52bf7bfb7e55"
          "5931d8a1-7532-4ae1-b21a-ab22ef6ee516"
          "7464f88f-e282-4cd7-b4ec-956276e9f709"
          "9293f22d-8d4f-466d-ac3e-9fc76731c2c9"
          "fba50444-598d-4e14-b7d3-f6bb0f03232c"
        ];
      };

      "org/gnome/desktop/app-folders/folders/4f9e09f6-cbd8-4a4a-beb3-9ec7b3e672ff" = {
        name = "Games";
        apps = [
          "org.gnome.Chess.desktop"
          "org.gnome.Sudoku.desktop"
          "org.gnome.Mines.desktop"
          "org.gnome.Quadrapassel.desktop"
          "osu!.desktop"
          "org.prismlauncher.PrismLauncher.desktop"
          "steam.desktop"
          "Steam Linux Runtime 1.0 (scout).desktop"
          "Steam Linux Runtime 2.0 (soldier).desktop"
          "Steam Linux Runtime 3.0 (sniper).desktop"
          "Proton Hotfix.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/3ef67acf-9b33-4087-9a9b-52bf7bfb7e55" = {
        name = "Social";
        apps = [
          "Zoom.desktop"
          "io.github.tobagin.karere.desktop"
          "teams-for-linux.desktop"
          "org.gnome.Fractal.desktop"
          "vesktop.desktop"
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
          "kvantummanager.desktop"
          "micro.desktop"
          "nixos-manual.desktop"
          "org.gnome.baobab.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.Devhelp.desktop"
          "org.gnome.dspy.desktop"
          "org.gnome.Logs.desktop"
          "org.gnome.Sysprof.desktop"
          "org.gnome.Tour.desktop"
          "xterm.desktop"
          "yelp.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/e57a32e8-8e5d-4808-aad7-b1f9152d01ee" = {
        name = "Accessories";
        apps = [
          "calibre-ebook-edit.desktop"
          "calibre-ebook-viewer.desktop"
          "calibre-lrfviewer.desktop"
          "qt5ct.desktop"
          "qt6ct.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/5931d8a1-7532-4ae1-b21a-ab22ef6ee516" = {
        name = "Internet";
        apps = [
          "de.haeckerfelix.Fragments.desktop"
          "firefox.desktop"
          "wihotspot.desktop"
          "org.gnome.Epiphany.desktop"
          "com.cloudflare.WarpTaskbar.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/7464f88f-e282-4cd7-b4ec-956276e9f709" = {
        name = "Writing";
        apps = [
          "Logseq.desktop"
          "org.cvfosammmm.Setzer.desktop"
          "com.github.xournalpp.xournalpp.desktop"
          "org.gnome.gitlab.somas.Apostrophe.desktop"
          "com.github.jeromerobert.pdfarranger.desktop"
          "dev.mufeed.Wordbook.desktop"
          "app.drey.Dialect.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/9293f22d-8d4f-466d-ac3e-9fc76731c2c9" = {
        name = "Graphics";
        apps = [
          "org.inkscape.Inkscape.desktop"
          "gimp.desktop"
          "fr.handbrake.ghb.desktop"
          "com.obsproject.Studio.desktop"
          "org.libvips.vipsdisp.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/fba50444-598d-4e14-b7d3-f6bb0f03232c" = {
        name = "Sound & Video";
        apps = [
          "spotify.desktop"
          "org.rncbc.qpwgraph.desktop"
          "com.stremio.Stremio.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/4bfbecbd-804e-4359-b1c2-00daef4c009e" = {
        name = "System";
        apps = [
          "nvidia-settings.desktop"
          "rog-control-center.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/1c3e59e4-a571-4ada-af1d-ed1ced384cfb" = {
        name = "Wine";
        apps = [
          "7zip.desktop"
          "com.usebottles.bottles.desktop"
          "net.lutris.Lutris.desktop"
          "Notepad++.desktop"
          "winetricks.desktop"
          "protontricks.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/cb1c8797-b52e-4df5-80d6-2c46e8f7ef22" = {
        name = "Android";
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
          "scrcpy.desktop"
          "scrcpy-console.desktop"
        ];
      };
    };
  }
)
