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
    package = pkgs.vscode;
    isGnome = osConfig.services.desktopManager.gnome.enable or false;
    isPantheon = osConfig.services.desktopManager.pantheon.enable or false;
    isHyprland = osConfig.programs.hyprland.enable or false;
  in {
    # Environment
    xdg.mimeApps.defaultApplications = util.build.mime {
      code = ["code.desktop"];
      markdown = ["code.desktop"];
      text = ["code.desktop"];
    };

    home = {
      packages = with pkgs; [
        nil
        alejandra
      ];
      persist.directories = [
        ".config/Code"
        ".vscode"
      ];
    };

    programs.vscode = {
      enable = true;
      inherit package;
      profiles.default = with files.vscode; {
        # Keyboard Shortcuts
        inherit keybindings;

        # Settings
        userSettings = lib.mkMerge [
          (settings // {
            "editor.fontFamily" = "'${font}', 'monospace', monospace";
          })
          (lib.mkIf isGnome {
            "workbench.colorTheme" = "Adwaita Dark";
            "workbench.productIconTheme" = "adwaita";
            "window.titleBarStyle" = "custom";
            "terminal.external.linuxExec" = "ghostty";
          })
          (lib.mkIf isPantheon {
            "workbench.colorTheme" = "Elementary Dark";
            "terminal.external.linuxExec" = "io.elementary.terminal";
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

            # Git
            eamodio.gitlens
            github.vscode-pull-request-github

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

            # HTML+CSS+XML
            ecmel.vscode-html-css
            formulahendry.auto-rename-tag
            redhat.vscode-xml

            # JS
            dbaeumer.vscode-eslint
            ritwickdey.liveserver
          ]
          ++ (with pkgs.vscode-marketplace; [
            kisstkondoros.vscode-gutter-preview # Image Preview
            fwcd.kotlin # Kotlin
          ])
          ++ lib.optionals isGnome [pkgs.vscode-extensions.piousdeer.adwaita-theme]
          ++ lib.optionals isPantheon [pkgs.vscode-marketplace.sixpounder.elementary-theme]
          ++ lib.optionals isHyprland [pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons];
      };
    };
  };
}
