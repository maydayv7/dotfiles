## Visual Studio Code Editor Configuration ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules.homeManager.vscode = {
    config,
    lib,
    pkgs,
    osConfig ? {},
    ...
  }: let
    font = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
    isGnome = osConfig.services.desktopManager.gnome.enable or false;
    isHyprland = osConfig.programs.hyprland.enable or false;
  in {
    # Environment
    imports = [./_mutable.nix];
    xdg.mimeApps.defaultApplications = util.build.mime {
      code = ["code.desktop"];
      markdown = ["code.desktop"];
      text = ["code.desktop"];
    };

    home = {
      persist.directories = [
        ".config/Code"
        ".vscode"
      ];
      packages = with pkgs; [
        nil
        alejandra
      ];
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = with files.vscode; {
        # Keyboard Shortcuts
        inherit keybindings;

        # Settings
        userSettings = lib.mkMerge [
          (settings
            // {
              "workbench.colorTheme" = lib.mkDefault "Dark 2026";
              "editor.fontFamily" = "'${font}', 'monospace', monospace";
            })
          (lib.mkIf isGnome {
            "workbench.productIconTheme" = "adwaita";
            "terminal.external.linuxExec" = "ghostty";
          })
          (lib.mkIf isHyprland {
            "workbench.iconTheme" = "catppuccin-${config.catppuccin.flavor or "mocha"}";
            "terminal.external.linuxExec" = "kitty";
          })
        ];

        ## Editor Extensions
        extensions = with pkgs.vscode-extensions;
          [
            aaron-bond.better-comments # Annotations
            editorconfig.editorconfig # .editorconfig
            esbenp.prettier-vscode # Formatter
            file-icons.file-icons # File Icons
            naumovs.color-highlight # Color Viewer
            johnpapa.vscode-peacock # Workspace Color

            github.vscode-pull-request-github # GitHub
            github.copilot # Copilot AI
            dart-code.flutter # Flutter
            divyanshuagrawal.competitive-programming-helper # CP
            jnoortheen.nix-ide # Nix
            ms-python.python # Python
            ms-vscode.cpptools # C/C++
            redhat.java # Java
            rust-lang.rust-analyzer # Rust
            tomoki1207.pdf # PDF Viewer
            yzhang.markdown-all-in-one # Markdown

            # HTML/CSS/XML
            ecmel.vscode-html-css
            formulahendry.auto-rename-tag
            redhat.vscode-xml

            # JS
            dbaeumer.vscode-eslint
            ritwickdey.liveserver
          ]
          ++ (with pkgs.vscode-marketplace; [
            kisstkondoros.vscode-gutter-preview # Image Preview
          ])
          ++ lib.optionals isGnome [pkgs.vscode-extensions.piousdeer.adwaita-theme]
          ++ lib.optionals isHyprland [pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons];
      };
    };
  };
}
