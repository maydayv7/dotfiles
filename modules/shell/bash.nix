{
  config,
  lib,
  pkgs,
  files,
  ...
}:
with files; let
  inherit (builtins) any attrValues elem mapAttrs;
  inherit (config.user) settings;
  enable = any (value: elem "bash" value.shells) (attrValues settings);
in {
  ## Bourne Shell Configuration ##
  config = lib.mkIf enable {
    # Shell Environment
    environment.shells = [pkgs.bashInteractive];
    user.persist = {
      files = [".bash_history"];
      dirs = [".local/share/bash"];
    };

    # Settings
    home-manager.users = mapAttrs (_: value:
      lib.mkIf (elem "bash" value.shells) {
        programs.bash = {
          enable = true;
          enableVteIntegration = true;

          # Options
          shellOptions = [
            "autocd"
            "cdspell"
            "checkjobs"
            "cmdhist"
            "histappend"
            "checkwinsize"
            "extglob"
            "globstar"
            "no_empty_cmd_completion"
          ];

          # Initialization
          initExtra =
            ''
              source <(${pkgs.cod}/bin/cod init $$ bash)
              eval $(${pkgs.thefuck}/bin/thefuck --alias "fix")
            ''
            # Prompt
            + ''
              function _update_ps1() {
                local old_exit_status=$?
                eval $(${pkgs.powerline-go}/bin/powerline-go -error $old_exit_status -shell bash -eval -modules "host,cwd,exit,jobs,git" -newline)
                return $old_exit_status
              }

              if [ "$TERM" != "linux" ]; then
                PROMPT_COMMAND="_update_ps1;$PROMPT_COMMAND"
              fi
            '';

          # Command History
          historySize = 100000;
          historyIgnore = ["rm" "pkill"];
          historyControl = ["erasedups" "ignoredups" "ignorespace"];
        };

        # Command Not Found Integration
        programs.nix-index.enableBashIntegration = true;

        # DirENV Integration
        programs.direnv.enableBashIntegration = true;
      })
    settings;
  };
}
