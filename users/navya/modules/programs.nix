{ config, lib, pkgs, ... }:
{
  programs =
  {
    home-manager.enable = true;
    
    # Z Shell
    zsh =
    {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      initExtraBeforeCompInit = "source ~/.p10k.zsh";
      shellAliases =
      {
        sike = "neofetch";
        do = "sudo";
        edit = "sudo nano";
        hi = "echo 'Hi there. How are you?'";
        bye = "exit";
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
      profile.navya =
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
      profiles.navya =
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
