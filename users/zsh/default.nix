{ config, lib, pkgs, ... }:
{
  # Z Shell
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
      lol = (builtins.readFile ./message);
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
        src = pkgs.fetchFromGitHub 
        {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
  
  home.file =
  {
    # Z Shell Prompt
    ".p10k.zsh".source = ./prompt;
    
    # Neofetch Config
    ".config/neofetch/config.conf".source = ./neofetch;
  };
  
  home.packages = with pkgs;
  [
    nix-zsh-completions
    fzf
    fzf-zsh
  ];
}
