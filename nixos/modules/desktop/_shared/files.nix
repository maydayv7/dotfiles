{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (lib)
    hm
    getExe
    getExe'
    mkIf
    replaceStrings
    ;

  inherit (config.gui) icons;
  terminal = "kitty";
  nemo = pkgs.nemo-with-extensions;
in
{
  ## File Manager Configuration
  config = mkIf config._shared.enable {
    services.dbus.packages = [ nemo ];
    environment.systemPackages = [
      nemo
    ]
    ++ (with pkgs; [
      cinnamon-desktop
      bulky
      file-roller
      lxqt.pcmanfm-qt
    ]);

    user.homeConfig = {
      xdg.mimeApps.defaultApplications = util.build.mime {
        archive = [ "org.gnome.FileRoller.desktop" ];
        directory = [ "nemo.desktop" ];
      };

      # Settings
      dconf.settings = {
        "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
        "org/nemo/search".search-reverse-sort = false;
        "org/nemo/desktop".show-desktop-icons = false;
        "org/nemo/plugins".disabled-actions = [ "change-background.nemo_action" ];
        "org/nemo/icon-view".captions = [
          "size"
          "type"
          "date_modified"
        ];

        "org/nemo/preferences" = {
          click-policy = "double";
          date-format = "informal";
          inherit-folder-viewer = true;
          quick-renames-with-pause-in-between = true;
          show-advanced-permissions = true;
          show-new-folder-icon-toolbar = false;
          show-show-thumbnails-toolbar = true;
          tooltips-in-icon-view = true;
          tooltips-in-list-view = false;
          tooltips-show-access-date = true;
          tooltips-show-birth-date = true;
          tooltips-show-file-type = true;
          tooltips-show-mod-date = true;
        };

        "org/nemo/preferences/menu-config" = {
          background-menu-open-in-terminal = false;
          selection-menu-open-in-terminal = false;
        };
      };

      home = {
        persist.directories = [
          ".config/nemo"
          ".local/share/nemo"
          ".config/pcmanfm-qt"
        ];

        # Bulk Renamer
        activation.nemo-rename = hm.dag.entryAfter [ "writeBoundary" ] ''
          if [[ -v DBUS_SESSION_BUS_ADDRESS ]]
          then
            export DCONF_DBUS_RUN_SESSION=""
          else
            export DCONF_DBUS_RUN_SESSION="${getExe' pkgs.dbus "dbus-run-session"} --dbus-daemon=${getExe' pkgs.dbus "dbus-daemon"}"
          fi

          run $DCONF_DBUS_RUN_SESSION ${getExe pkgs.dconf} write /org/nemo/preferences/bulk-rename-tool "b'bulky'"
          unset DCONF_DBUS_RUN_SESSION
        '';

        file = {
          # Open in Terminal
          ".local/share/nemo/actions/terminal.nemo_action".text = ''
            [Nemo Action]
            Name=Open in Terminal
            Comment=Opens ${terminal} in the selected folder
            Exec=${terminal} --working-directory=%F
            Icon-Name=${terminal}
            Selection=any
            Extensions=dir;
            EscapeSpaces=true
          '';

          # Desktop Icons
          ".config/pcmanfm-qt/default/settings.conf".text =
            replaceStrings
              [
                "@icon"
                "@font"
                "@terminal"
                "@wallpaper"
                "@archiver"
              ]
              [
                icons.name
                config.stylix.fonts.sansSerif.name
                terminal
                (builtins.toString files.images.transparent)
                "file-roller"
              ]
              files.pcmanfm;
        };
      };
    };
  };
}
