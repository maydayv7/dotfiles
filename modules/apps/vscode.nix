{
  config,
  lib,
  util,
  pkgs,
  files,
  ...
}:
with files.vscode; let
  inherit (builtins) elem head;
  enable = elem "vscode" config.apps.list;
  font = head config.fonts.fontconfig.defaultFonts.monospace;
in {
  ## Visual Studio Code Editor Configuration ##
  config = lib.mkIf enable {
    environment.systemPackages = with pkgs; [nil vscode];

    user = {
      persist.directories = [".config/Code" ".vscode"];
      homeConfig = {
        xdg.mimeApps.defaultApplications = util.build.mime files.xdg.mime {
          text = ["code.desktop"];
        };

        programs.vscode = {
          enable = true;
          package = pkgs.vscode;

          # Keyboard Shortcuts
          inherit keybindings;

          # Settings
          userSettings =
            settings // {"editor.fontFamily" = "'${font}', 'monospace', monospace";};

          # Useful Extensions
          extensions = with pkgs.vscode-extensions;
            [
              dotjoshjohnson.xml
              eamodio.gitlens
              editorconfig.editorconfig
              esbenp.prettier-vscode
              file-icons.file-icons
              github.vscode-pull-request-github
              jnoortheen.nix-ide
              kamadorueda.alejandra
              ms-python.python
              ms-vscode-remote.remote-ssh
              ms-vscode.cpptools
              redhat.java
              redhat.vscode-yaml
              yzhang.markdown-all-in-one
            ]
            # Custom Extensions
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "better-comments";
                publisher = "aaron-bond";
                version = "3.0.2";
                sha256 = "sha256-hQmA8PWjf2Nd60v5EAuqqD8LIEu7slrNs8luc3ePgZc=";
              }
              {
                name = "org-mode";
                publisher = "vscode-org-mode";
                version = "1.0.0";
                sha256 = "sha256-o9CIjMlYQQVRdtTlOp9BAVjqrfFIhhdvzlyhlcOv5rY=";
              }
              {
                name = "vscode-html-css";
                publisher = "ecmel";
                version = "1.13.1";
                sha256 = "sha256-gBfcizgn+thCqpTa8bubh6S77ynBC/Vpc+7n4XOfqzE=";
              }
            ];
        };
      };
    };
  };
}
