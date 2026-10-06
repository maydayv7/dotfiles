## Text Editor
{
  util ? null,
  files ? null,
  ...
}: {
  nixos = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.xed-editor.overrideAttrs (old: {
        preFixup =
          (old.preFixup or "")
          + ''
            gappsWrapperArgs+=(
              --prefix GI_TYPELIB_PATH : "$out/lib/xed/girepository-1.0"
              --prefix PYTHONPATH : "${pkgs.python3Packages.makePythonPath [pkgs.python3Packages.pycairo]}"
            )
          '';
      }))
    ];
  };

  home = {
    config,
    pkgs,
    ...
  }: {
    xdg.mimeApps.defaultApplications = util.build.mime {
      markdown = ["org.x.editor.desktop"];
      text = ["org.x.editor.desktop"];
    };

    dconf.settings = {
      "org/x/editor/preferences/editor" = {
        auto-close = true;
        auto-indent = true;
        bracket-matching = true;
        display-line-numbers = true;
        display-right-margin = false;
        draw-whitespace = false;
        ensure-trailing-newline = false;
        highlight-current-line = true;
        scheme = "custom";
      };

      "org/x/editor/preferences/ui" = {
        minimap-visible = true;
        side-panel-visible = false;
        statusbar-visible = true;
      };

      "org/x/editor/plugins".active-plugins = [
        "open-uri-context-menu"
        "textsize"
        "docinfo"
        "time"
        "filebrowser"
        "joinlines"
        "modelines"
        "spell"
        "bracketcompletion"
        "sort"
        "xed_find_in_files"
        "xed_split_pane"
        "xed_smart_overview"
        "xed_quick_highlight"
        "xed_indentation_guides"
      ];
    };

    home = {
      persist.directories = [
        ".config/xed"
        ".config/xed-find-in-files"
        ".local/share/xed"
        ".cache/xed"
        ".config/enchant"
      ];

      file = {
        ".local/share/xed/styles/custom.xml".text = util.build.theme {
          colors = config.lib.stylix.colors;
          file = files.hyprland.xed;
        };

        ".local/share/xed/plugins" = {
          source = "${pkgs.custom.xed-extra-plugins}/share/xed/plugins";
          recursive = true;
        };
      };
    };
  };
}
