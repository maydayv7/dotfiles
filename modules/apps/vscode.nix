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
  config = lib.mkIf enable rec {
    environment.systemPackages = [pkgs.nil user.homeConfig.programs.vscode.package];

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
            ++ (with pkgs.code.vscode-marketplace; [
              aaron-bond.better-comments
              ecmel.vscode-html-css
              vscode-org-mode.org-mode
            ]);
        };
      };
    };
  };
}
