## Shell Configuration ##
{config, ...}: let
  inherit (config.flake) files;
in {
  flake.modules = {
    nixos.shell = {pkgs, ...}: {
      config = {
        # Text Editor
        environment.variables."EDITOR" = "nano";
        programs = {
          nano = {
            enable = true;
            syntaxHighlight = true;
            nanorc = files.nano;
          };

          # Terminal Multiplexer
          tmux = {
            enable = true;
            keyMode = "emacs";
            shortcut = "Space";
            aggressiveResize = true;
            baseIndex = 1;
            clock24 = true;
            escapeTime = 0;
            historyLimit = 50000;
            terminal = "tmux-256color";
            extraConfig = files.tmux;
          };

          # Bourne Shell
          bash = {
            vteIntegration = true;
            promptInit = ''
              shopt -s autocd
              shopt -s cdspell
              shopt -s checkjobs
              shopt -s checkwinsize
              shopt -s cmdhist
              shopt -s extglob
              shopt -s globstar
              shopt -s histappend

              HISTCONTROL=erasedups:ignoredups:ignorespace
              HISTFILESIZE=100000
              HISTIGNORE=rm:killall
              HISTSIZE=100000
            '';
          };

          # Z Shell
          zsh = {
            enable = true;
            autosuggestions.enable = true;
            enableCompletion = false;
            syntaxHighlighting.enable = true;
            vteIntegration = true;
            setOptions = [
              "autocd"
              "EXTENDED_HISTORY"
              "HIST_EXPIRE_DUPS_FIRST"
            ];

            promptInit = ''
              bindkey '^[[1;5C' forward-word
              bindkey '^[[1;5D' backward-word
              bindkey '^[[3;5~' kill-word
              bindkey '^[[3~'   delete-char
              bindkey "^[[5~"   beginning-of-history
              bindkey "^[[6~"   end-of-history
              bindkey '^[[A'    up-line-or-search
              bindkey '^[[B'    down-line-or-search
              bindkey '^[[C'    forward-char
              bindkey '^[[D'    backward-char
              bindkey '^[[F'    end-of-linegestures
              bindkey '^[[H'    beginning-of-line
              bindkey '^J'      backward-kill-line
            '';

            interactiveShellInit = ''
              source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
            '';
          };
        };

        environment.shells = [pkgs.bashInteractive];
        system.userActivationScripts.zshrc = "touch .zshrc";
      };
    };

    homeManager.shell = _: {
      home.persist = {
        files = [
          ".bash_history"
          ".zsh_history"
        ];
        directories = [
          ".local/share/bash"
          ".cache/zsh"
        ];
      };
    };
  };
}
