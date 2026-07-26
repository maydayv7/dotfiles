## Shell Configuration ##
{config, ...}: let
  inherit (config.flake) files;

  editor = {
    autoindent = true;
    backup = true;
    clipboard = "external";
    cursorline = true;
    eofnewline = false;
    helpsplit = "vsplit";
    hltrailingws = true;
    infobar = true;
    matchbrace = true;
    keymenu = true;
    mouse = true;
    reload = "prompt";
    ruler = true;
    saveundo = true;
    scrollbar = true;
    smartpaste = true;
    statusline = true;
    syntax = true;
  };
in {
  flake.modules = {
    nixos.shell = {pkgs, ...}: {
      config = {
        environment = {
          shells = [pkgs.bashInteractive];

          # Text Editor
          variables."EDITOR" = "micro";
          systemPackages = [pkgs.micro];
          interactiveShellInit = ''
            e() { "''${EDITOR:-nano}" "$@"; }
          '';
        };

        systemd.tmpfiles.rules = let
          settings = pkgs.writeText "micro-settings.json" (builtins.toJSON editor);
        in [
          "d /root/.config 0700 root root -"
          "d /root/.config/micro 0700 root root -"
          "L+ /root/.config/micro/settings.json - - - - ${settings}"
        ];

        programs = {
          nano = {
            enable = true;
            syntaxHighlight = true;
            nanorc = files.nano;
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
          ".config/micro"
          ".local/share/bash"
          ".cache/zsh"
        ];
      };

      programs = {
        bash.enable = true;
        zsh.enable = true;

        # Text Editor
        micro = {
          enable = true;
          settings = editor;
        };
      };
    };
  };
}
