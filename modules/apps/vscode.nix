{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
let
  inherit (builtins) elem head;
  enable = elem "vscode" config.apps.list;
  font = head config.fonts.fontconfig.defaultFonts.monospace;
in
{
  ## Visual Studio Code Editor Configuration ##
  config = lib.mkIf enable rec {
    environment.systemPackages = [
      pkgs.nil
      user.homeConfig.programs.vscode.package
    ];

    user = {
      persist.directories = [
        ".config/Code"
        ".vscode"
      ];

      homeConfig = {
        # Mutable Configuration File
        imports = [
          (
            { config, ... }:
            (import (builtins.fetchurl {
              inherit (files.mutability.vscode) url sha256;
            }) { inherit config lib pkgs; })
          )
        ];

        # Environment
        xdg.mimeApps.defaultApplications = util.build.mime {
          markdown = [ "code.desktop" ];
          text = [ "code.desktop" ];
        };

        programs.vscode = {
          enable = true;
          package = pkgs.vscode;
          profiles.default = with files.vscode; {
            # Keyboard Shortcuts
            inherit keybindings;

            # Settings
            userSettings = settings // {
              "editor.fontFamily" = "'${font}', 'monospace', monospace";
            };

            ## Editor Extensions
            extensions =
              with pkgs.vscode-extensions;
              [
                aaron-bond.better-comments # Annotations
                editorconfig.editorconfig # .editorconfig
                esbenp.prettier-vscode # Formatter
                file-icons.file-icons # File Icons
                naumovs.color-highlight # Color Viewer

                # Git
                eamodio.gitlens
                github.vscode-pull-request-github

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
              ++ (with pkgs.code.vscode-marketplace; [
                kisstkondoros.vscode-gutter-preview # Image Preview
              ]);
          };
        };
      };
    };
  };
}
