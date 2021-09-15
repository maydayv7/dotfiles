{ config, lib, pkgs, ... }:
{
  programs =
  {
    home-manager.enable = true;
    
    # Task Manager
    htop.enable = true;
    
    # Git
    git =
    {
      enable = true;
      aliases =
      {
        ci = "commit";
        co = "checkout";
        st = "status";
        sum = "log --graph --decorate --oneline --color --all";
      };
      delta.enable = true;
      extraConfig =
      {
        color.ui = "auto";
        pull.rebase = "false";
      };
      userName = "maydayv7";
      userEmail = "maydayv7@gmail.com";
    };
    
    # Z Shell
    zsh =
    {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      initExtraBeforeCompInit =
      "
        source ~/.p10k.zsh
      ";
      shellAliases =
      {
        sike = "neofetch";
        do = "sudo";
        edit = "sudo nano";
        hi = "echo 'Hi there. How are you?'";
        bye = "exit";
        config = "cd /data/V7/Other/Projects/nixos-config";
        update = "sudo nix-channel --update";
        upgrade = "sudo nixos-rebuild switch";
        cleanup = "sudo nix-collect-garbage -d";
      };
      history =
      {
        size = 10000;
        path = ".zsh/history";
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
    
    # GNOME Terminal
    gnome-terminal =
    {
      enable = true;
      profile.v7 =
      {
        default = true;
        visibleName = "Terminal";
        audibleBell = false;
        cursorShape = "ibeam";
        scrollbackLines = 70000;
      };
    };
    
    # Firefox
    firefox =
    {
      enable = true;
      profiles.v7 =
      {
        settings = 
        {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.download.dir" = "/home/v7/Downloads";
        };
      };
    };
  };
}
