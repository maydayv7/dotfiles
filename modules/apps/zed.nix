## Zed Editor ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules.homeManager.zed = {
    config,
    pkgs,
    ...
  }: {
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

    home.persist.directories = [
      ".config/zed"
      ".local/share/zed"
    ];

    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor;

      # Settings
      userSettings =
        files.zed.settings
        // (with config.stylix.fonts; {
          "ui_font_family" = sansSerif.name;
          "buffer_font_family" = monospace.name;
        });
      userKeymaps = files.zed.keymap;

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

      extraPackages = with pkgs; [
        nixd
        alejandra
        clang-tools # C/C++
        rust-analyzer # Rust
        gopls # Go
        basedpyright # Python
        bash-language-server # Bash
        vscode-langservers-extracted # HTML/CSS/JSON
        yaml-language-server # YAML
        marksman # Markdown
        taplo # TOML
        texlab # LaTeX
        dockerfile-language-server # Docker
      ];
    };
  };
}
