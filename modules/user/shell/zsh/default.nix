{ config, lib, inputs, pkgs, ... }:
let
  enable = config.shell.zsh.enable;
in rec
{
  options.shell.zsh.enable = lib.mkOption
  {
    description = "User ZSH Configuration";
    type = lib.types.bool;
    default = false;
  };

  ## User Z Shell Configuration ##
  config = lib.mkIf enable
  {
    programs.zsh =
    {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      initExtra =''bindkey "\e[3~" delete-char'';
      initExtraBeforeCompInit = "source ~/.p10k.zsh";
      shellAliases =
      {
        sike = "neofetch";
        do = "sudo";
        edit = "sudo nano";
        hi = "echo 'Hi there. How are you?'";
        bye = "exit";
        lol = "echo \"${builtins.readFile ./message}\"";
        dotfiles = "cd /etc/nixos";
      };
      history =
      {
        size = 1000000000;
        ignoreDups = true;
        expireDuplicatesFirst = true;
        ignorePatterns = [ "rm *" "pkill *" ];
      };
      plugins =
      [
        {
          name = "zsh-syntax-highlighting";
          src = inputs.zsh-syntax;
          file = "zsh-syntax-highlighting.zsh";
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
    };

    # Z Shell Prompt
    home.file.".p10k.zsh".source = ./prompt;

    # Command Not Found Helper
    programs.nix-index =
    {
      enable = true;
      enableZshIntegration = true;
    };

    # DirENV Integration
    programs.direnv =
    {
      enable = true;
      enableZshIntegration = true;
      nix-direnv =
      {
        enable = true;
        enableFlakes = true;
      };
    };

    # Utilities
    home.packages = with pkgs;
    [
      fzf
      fzf-zsh
    ];
  };
}
