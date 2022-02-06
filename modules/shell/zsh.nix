{ config, lib, pkgs, files, ... }:
with files;
let enable = builtins.elem "zsh" config.shell.support;
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
    user.home = {
      programs.zsh = {
        enable = true;

        # Features
        enableAutosuggestions = true;
        enableCompletion = true;
        enableVteIntegration = true;
        autocd = true;

        # Initialization
        initExtraBeforeCompInit = ''
          source ~/.p10k.zsh
          eval $(${pkgs.thefuck}/bin/thefuck --alias "fix")
        '';

        initExtra = ''
          bindkey "\e[3~" delete-char
          bindkey '^[[H' beginning-of-line
          bindkey '^[[F' end-of-line
          source <(cod init $$ zsh)
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
            file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          }
        ];
      };

      # Utilities
      home.packages = with pkgs; [ cod fzf fzf-zsh ];

      # Z Shell Prompt
      home.file.".p10k.zsh".text = zsh.prompt;

      # Command Not Found Integration
      programs.nix-index.enableZshIntegration = true;

      # DirENV Integration
      programs.direnv.enableZshIntegration = true;
    };
  };
}
