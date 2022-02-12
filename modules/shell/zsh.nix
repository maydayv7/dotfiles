{ config, lib, pkgs, files, ... }:
with files;
let
  inherit (builtins) any attrValues elem mapAttrs;
  inherit (config.user) settings;
  enable = any (value: elem "zsh" value.shells) (attrValues settings);
in {
  ## Z Shell Configuration ##
  config = lib.mkIf enable {
    # Shell Environment
    user.persist = {
      files = [ ".zsh_history" ];
      dirs = [ ".cache/zsh" ];
    };

    environment = {
      shells = [ pkgs.zsh ];
      pathsToLink = [ "/share/zsh" ];
    };

    # Settings
    home-manager.users = mapAttrs (_: value:
      lib.mkIf (elem "zsh" value.shells) {
        programs.zsh = {
          enable = true;

          # Features
          autocd = true;
          enableAutosuggestions = true;
          enableCompletion = true;
          enableVteIntegration = true;

          # Initialization
          initExtraBeforeCompInit = ''
            source ~/.p10k.zsh
            eval $(${pkgs.thefuck}/bin/thefuck --alias "fix")
          '';

          initExtra = ''
            source <(${pkgs.cod}/bin/cod init $$ zsh)
          ''
            # Keybindings
            + ''
              bindkey '^[[3~'   delete-char
              bindkey '^[[H'    beginning-of-line
              bindkey '^[[F'    end-of-line
              bindkey '^[[1;5C' forward-word
              bindkey '^[[1;5D' backward-word
              bindkey '^H'      backward-kill-word
              bindkey '^[[3;5~' kill-word
              bindkey '^J'      backward-kill-line
              bindkey '^[[D'    backward-char
              bindkey '^[[C'    forward-char
              bindkey '^[[A'    up-line-or-beginning-search
              bindkey '^[[B'    down-line-or-beginning-search
            '';

          # Command History
          history = {
            extended = true;
            ignoreDups = true;
            expireDuplicatesFirst = true;
            ignorePatterns = [ "rm *" "pkill *" ];
          };

          # Additional Plugins
          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
              name = "zsh-autopair";
              src = pkgs.zsh-autopair;
              file = "share/zsh/zsh-autopair/autopair.zsh";
            }
            {
              name = "zsh-syntax-highlighting";
              src = pkgs.zsh-syntax-highlighting;
              file =
                "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
            }
          ];
        };

        # Utilities
        home.packages = with pkgs; [ fzf fzf-zsh ];

        # Prompt
        home.file.".p10k.zsh".text = zsh.prompt;

        # Command Not Found Integration
        programs.nix-index.enableZshIntegration = true;

        # DirENV Integration
        programs.direnv.enableZshIntegration = true;
      }) settings;
  };
}
