## File Manager
{
  util ? null,
  files ? null,
  inputs ? null,
  ...
}: let
  strataPkg = pkgs:
    pkgs.unstable.callPackage "${inputs.strata}/package.nix" {
      rarSupport = true;
      buildCommit = inputs.strata.shortRev;
    };
in {
  nixos = {
    pkgs,
    lib,
    ...
  }: let
    strata = strataPkg pkgs;
  in {
    services.udisks2.enable = true;
    services.dbus.packages = [strata.fileManagerService];
    xdg.portal = {
      extraPortals = [strata.fileChooserPortal];
      config = lib.genAttrs ["common" "hyprland" "niri"] (_: {
        "org.freedesktop.impl.portal.FileChooser" = ["strata" "gtk"];
      });
    };

    environment.systemPackages = [
      strata
      pkgs.file-roller
    ];
  };

  home = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # Desktop icons
    imports = [inputs.dicons.homeManagerModules.default];
    services.dicons = {
      enable = true;
      settings.show-trash = true;
    };

    dconf.settings."org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;

    xdg.mimeApps.defaultApplications = util.build.mime {
      archive = ["org.gnome.FileRoller.desktop"];
      directory = ["io.github.lgse.Strata.desktop"];
    };

    home = {
      persist.directories = [
        ".config/strata"
        ".local/share/strata"
        ".local/state/strata"
      ];

      file = let
        mutable = source: {
          inherit source;
          mutable = true;
          force = true;
        };

        toml = pkgs.formats.toml {};
        action = id: name: icon:
          toml.generate "strata-${id}.toml" {
            schema_version = 1;
            inherit id name icon;
            enabled = true;
            menu = "top";
            when = {
              kinds = ["file" "folder"];
              min_items = 1;
            };
            run = {
              mode = "whole-selection";
              working_directory = "parent";
              confirm = false;
              runtime = "python";
              entrypoint = "run.py";
            };
          };
        action-run = name: file:
          pkgs.writeText "strata-${name}.py" (
            lib.replaceStrings
            ["@python@" "@zenity@"]
            [(toString pkgs.python3) (lib.getExe pkgs.zenity)]
            file
          );
      in {
        ".config/strata/settings.toml" = mutable (toml.generate "strata-settings.toml" {
          mode = "theme";
          theme = "stylix";
          interface_font = config.stylix.fonts.sansSerif.name;
          text_size = builtins.floor (config.stylix.fonts.sizes.applications * 4.0 / 3.0 + 0.5);
          folders_first = true;
          date_format = "relative";
          check_for_updates = false;
          browser_mode = "columns";
          browser_density = "compact";
          frame_density = "compact";
          window_show_close = false;
          window_show_maximize = false;
          window_show_minimize = false;
          list_file_clicks = 2;
          list_folder_clicks = 1;
          grid_file_clicks = 2;
          grid_folder_clicks = 2;
          explorer_file_clicks = 2;
          explorer_folder_clicks = 2;
        });

        ".config/strata/themes/stylix.toml".source = toml.generate "strata-theme.toml" (
          with config.lib.stylix.colors.withHashtag; {
            name = "Stylix";
            background = base00;
            surface = base01;
            text = base05;
            accent = base0D;
            danger = base08;
            muted = base02;
            highlight = base02;
            border = base03;
            dim_text = "#a5adcb";
            syntax_keyword = base0E;
            syntax_string = base0B;
            syntax_constant = base09;
            syntax_type = base0A;
            syntax_preprocessor = base0C;
          }
        );

        # Custom Actions
        ".config/strata/actions/batch-rename/action.toml" = mutable (action "batch-rename" "Bulk Rename…" "pencil");
        ".config/strata/actions/batch-rename/run.py" = mutable (action-run "rename" files.strata.rename);
        ".config/strata/actions/make-symlink/action.toml" = mutable (action "make-symlink" "Create Symlink" "copy");
        ".config/strata/actions/make-symlink/run.py" = mutable (action-run "symlink" files.strata.symlink);

        ".config/strata/providers/kdeconnect/provider.json" = mutable (pkgs.writeText "strata-kdeconnect.json" (builtins.toJSON {
          version = 1;
          id = "kdeconnect";
          name = "KDE Connect";
          category = "devices";
          command = [
            (toString (pkgs.writeShellScript "strata-kdeconnect" ''
              export GI_TYPELIB_PATH=${lib.escapeShellArg "${pkgs.glib.out}/lib/girepository-1.0"}
              exec ${pkgs.python3.withPackages (p: [p.pygobject3])}/bin/python3 ${inputs.strata}/integrations/kdeconnect/provider.py "$@"
            ''))
          ];
        }));
      };
    };
  };
}
