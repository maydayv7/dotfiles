{
  config,
  lib,
  pkgs,
  ...
}: let
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
      directories = [".local/share/bash"];
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

          # Prompt
          initExtra = ''
            function _update_ps1() {
              local old_exit_status=$?
              eval $(${lib.getExe pkgs.powerline-go} -error $old_exit_status -shell bash -eval -modules "host,cwd,exit,jobs,git" -newline)
              return $old_exit_status
            }

            if [ "$TERM" != "linux" ]; then
              PROMPT_COMMAND="_update_ps1;$PROMPT_COMMAND"
            fi
          '';

          # Command History
          historySize = 100000;
          historyIgnore = ["rm" "killall"];
          historyControl = ["erasedups" "ignoredups" "ignorespace"];
        };
      })
    settings;
  };
}
