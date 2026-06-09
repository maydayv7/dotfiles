# Visual Studio Code Editor
## Visual Studio Code Editor Configuration ##
{config, ...}: let
  inherit (config) util;
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.vscode = {pkgs, ...}: {
      environment.systemPackages =
        [
          pkgs.vscode
        ]
        ++ (with pkgs; [
          nil
          alejandra
        ]);
    };

    homeManager.vscode = {
      config,
      pkgs,
      ...
    }: let
      font = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
      package = pkgs.vscode;
    in {
      # Environment
      xdg.mimeApps.defaultApplications = util.build.mime {
        code = ["code.desktop"];
        markdown = ["code.desktop"];
        text = ["code.desktop"];
      };

      home.persist.directories = [
        ".config/Code"
        ".vscode"
      ];

      programs.vscode = {
        enable = true;
        inherit package;
        profiles.default = with files.vscode; {
          # Keyboard Shortcuts
          inherit keybindings;

          # Settings
          userSettings =
            settings
            // {
              "editor.fontFamily" = "'${font}', 'monospace', monospace";
            };

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
            ]);
        };
      };
    };
  };
}
