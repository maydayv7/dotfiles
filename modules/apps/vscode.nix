{
  config,
  lib,
  inputs,
  pkgs,
  files,
  ...
}:
with files.vscode; let
  inherit (lib) mkIf util;
  inherit (builtins) elem head;
  enable = elem "vscode" config.apps.list;
  font = head config.fonts.fontconfig.defaultFonts.monospace;
in {
  ## Visual Studio Code Editor Configuration ##
  config = mkIf enable {
    environment.systemPackages = with pkgs; [rnix-lsp vscode];

    user = {
      persist.dirs = [".config/Code" ".vscode"];
      home = {
        imports = ["${inputs.vscode}/modules/vscode-server/home.nix"];

        xdg.mimeApps.defaultApplications = util.build.mime files.xdg.mime {
          text = ["code.desktop"];
        };

        services.vscode-server.enable = true;
        programs.vscode = {
          enable = true;
          package = pkgs.vscode;

          # Keyboard Shortcuts
          inherit keybindings;

          # Settings
          userSettings =
            settings // {"editor.fontFamily" = "'${font}', 'monospace', monospace";};

          # Useful Extensions
          extensions = with pkgs;
          with unstable.vscode-extensions // vscode-extensions;
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
                version = "2.1.0";
                sha256 = "sha256-l7MG2bpfTgVgC+xLal6ygbxrrRoNONzOWjs3fZeZtU4=";
              }
              {
                name = "org-mode";
                publisher = "vscode-org-mode";
                version = "1.0.0";
                sha256 = "1dp6mz1rb8awrrpig1j8y6nyln0186gkmrflfr8hahaqr668il53";
              }
              {
                name = "vscode-html-css";
                publisher = "ecmel";
                version = "1.11.0";
                sha256 = "sha256-xwzfTFSBonGcfyhE0fs1ZRHlRbPFLGgshw1NLLyFypI=";
              }
            ];
        };
      };
    };
  };
}
