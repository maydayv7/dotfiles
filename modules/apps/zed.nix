## Zed Editor ##
{config, ...}: let
  inherit (config) util;
in {
  flake.modules.homeManager.zed = {
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: let
    isGnome = osConfig.services.desktopManager.gnome.enable or false;
    isWM = (osConfig.programs.hyprland.enable or false) || (osConfig.programs.niri.enable or false);
  in {
    xdg.mimeApps = let
      mime = util.build.mime {
        code = ["dev.zed.Zed.desktop"];
        markdown = ["dev.zed.Zed.desktop"];
        text = ["dev.zed.Zed.desktop"];
      };
    in {
      defaultApplications = mime;
      associations.added = mime;
    };

    home.persist.directories = [".config/zed"];
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
      extraPackages = with pkgs; [
        nixd
        alejandra
      ];

      ## Settings
      userSettings = lib.mkMerge [
        {
          # Editor
          "format_on_save" = "on";
          "ensure_final_newline_on_save" = true;
          "remove_trailing_whitespace_on_save" = true;
          "cursor_blink" = true;
          "cursor_shape" = "bar";
          "scrollbar"."show" = "auto";
          "use_smartcase_search" = true;
          "autosave" = "on_window_change";
          "close_on_file_delete" = true;
          "when_closing_with_no_tabs" = "close_window";

          # Terminal
          "terminal"."cursor_shape" = "bar";

          # Telemetry
          "auto_update" = false;
          "features"."edit_prediction_provider" = "none";
          "telemetry" = {
            "diagnostics" = false;
            "metrics" = false;
          };

          # Icons
          "icon_theme" = lib.mkDefault "Material Icon Theme";

          # Formatters
          "languages"."Nix" = {
            "language_servers" = ["nixd"];
            "formatter"."external" = {
              "command" = "alejandra";
              "arguments" = ["-q" "-"];
            };
          };
        }
        (lib.mkIf isGnome {
          "terminal"."shell"."program" = "ghostty";
        })
        (lib.mkIf isWM {
          "terminal"."shell"."program" = "kitty";
        })
      ];

      # Keymaps
      userKeymaps = [
        {
          context = "Workspace";
          bindings = {
            "ctrl-/" = "command_palette::Toggle";
            "alt-t" = "terminal_panel::ToggleFocus";
            "ctrl-shift-t" = "workspace::NewTerminal";
          };
        }
        {
          context = "Editor";
          bindings = {
            "ctrl-d" = "editor::DeleteLine";
            "ctrl-'" = "editor::ToggleComments";
          };
        }
      ];

      ## Extensions
      extensions = [
        "nix" # Nix
        "dart" # Flutter/Dart
        "java" # Java
        "html" # HTML
        "toml" # TOML
        "dockerfile" # Docker
        "make" # Makefiles
        "sql" # SQL
        "basher" # Bash
        "latex" # LaTeX
        "log" # Log Files
        "git-firefly" # Git
        "material-icon-theme" # File Icons
      ];
    };
  };
}
