{ config, lib, pkgs, files, ... }:
let shell = config.user.shell.choice;
in rec {
  ## Z Shell Configuration ##
  config = lib.mkIf (shell == "zsh") {
    # Shell Environment
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
        initExtraBeforeCompInit = ''
          bindkey "\e[3~" delete-char
          source ~/.p10k.zsh
          eval $(${pkgs.thefuck}/bin/thefuck --alias "fix")
        '';

        # Command Aliases
        shellAliases = {
          hi = "echo 'Hi there. How are you?'";
          bye = "exit";
          lol = ''echo "${files.zsh.lol}"'';
          ls = "ls --color --group-directories-first";
          sike = "neofetch";
          dotfiles = "cd ${files.path}";
          edit = "sudo $EDITOR";
        };

        # Command History
        history = {
          extended = true;
          ignoreDups = true;
          expireDuplicatesFirst = true;
          ignorePatterns = [ "rm *" "pkill *" ];
        };

        # Extra Shell Plugins
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.zsh-syntax-highlighting;
            file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
          }
        ];
      };

      home.file = {
        # Z Shell Prompt
        ".p10k.zsh".text = files.zsh.prompt;

        # Neofetch Configuration
        ".config/neofetch/config.conf".text = files.fetch;
      };

      # Command Not Found Helper
      programs.nix-index = {
        enable = true;
        enableZshIntegration = true;
      };

      # DirENV Integration
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      # Utilities
      home.packages = with pkgs; [ fzf fzf-zsh neofetch lolcat ];
    };
  };
}
