## Shared Editor Profile
{
  lib,
  pkgs,
  files,
  font,
  isGnome,
  isWM,
}:
with files.vscode; {
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
    (lib.mkIf isWM {
      "terminal.external.linuxExec" = "kitty";
    })
    (let
      lemminx = "${pkgs.lemminx}/bin/lemminx";
    in {
      "xml.server.preferBinary" = true;
      "xml.server.binary.path" = lemminx;
      "xml.server.binary.trustedHashes" = [(builtins.hashFile "sha256" lemminx)];
      "direnv.restart.automatic" = true;
      "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
      "direnv.status.show" = true;
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

      mkhl.direnv # Direnv Integration
      github.vscode-pull-request-github # GitHub
      dart-code.dart-code # Dart
      dart-code.flutter # Flutter
      jnoortheen.nix-ide # Nix
      ms-vscode.cpptools # C/C++
      redhat.java # Java
      rust-lang.rust-analyzer # Rust
      tombi-toml.tombi # TOML
      yzhang.markdown-all-in-one # Markdown

      # Python
      ms-python.python
      charliermarsh.ruff
      detachhead.basedpyright

      # HTML/CSS/XML
      ecmel.vscode-html-css
      redhat.vscode-xml

      # JS
      dbaeumer.vscode-eslint
      ms-vscode.live-server # Live Preview
    ]
    ++ (with pkgs.vscode-marketplace; [
      cweijan.vscode-office # Document Viewer
      bruno-api-client.bruno # API Client
      langningchen.cph-ng # CP
    ])
    ++ lib.optionals isGnome [pkgs.vscode-extensions.piousdeer.adwaita-theme];
}
