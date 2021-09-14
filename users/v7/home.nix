{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
in
{
  imports = [(import "${home-manager}/nixos")];
  
  # Home Configuration
  home-manager.users.v7 =
  {
    home =
    {
      # User Packages
      packages = with pkgs;
      [
        bluej
        calibre
        teams
        zoom-us
        
        # GNOME Circle
        apostrophe
        drawing
        deja-dup
        giara
        gimp
        gnome-podcasts
        gnome-passwordsafe
        kooha
        shortwave 
        
        # Unstable Packages
        #fragments
        #markets
        #wike
        
        # GNOME Shell Extensions
        gnomeExtensions.appindicator
        gnomeExtensions.caffeine
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.compiz-windows-effect
        gnomeExtensions.compiz-alike-magic-lamp-effect
        gnomeExtensions.custom-hot-corners-extended
        gnomeExtensions.dash-to-panel
        gnomeExtensions.just-perfection
        gnomeExtensions.lock-keys
        gnomeExtensions.screenshot-locations
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.vitals
      ];
      
      # Dotfiles
      file =
      {
        ".p10k.zsh".source = ./config/zsh-theme;
        ".config/neofetch/config.conf".source = ./config/neofetch;
        ".config/touchegg/touchegg.conf".source = ./config/gestures;
        ".themes/Adwaita/gnome-shell/gnome-shell.css".source = ./config/theme;
        ".local/share/gtksourceview-4/language-specs/nix.lang".source = ./config/syntax;
        ".local/share/gtksourceview-4/styles/tango-dark.xml".source = ./config/colors;
        ".mozilla/firefox/v7/user.js".source = ./config/firefox/firefox-gnome-theme/configuration/user.js;
        ".mozilla/firefox/v7/chrome" =
        {
          source = ./config/firefox;
          recursive = true;
        };
      };
    };
    
    # Theming
    gtk =
    {
      enable = true;
      theme =
      {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
      iconTheme =
      {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
    
    qt =
    {
      enable = true;
      platformTheme = "gnome";
      style =
      {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    # Overlays
    nixpkgs.overlays =
    [
      (import ./overlays/dash.nix)
    ];
    
    # User Program Configuration
    programs =
    {
      home-manager.enable = true;
      htop.enable = true;
      
      # Git Configuration
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
      
      # Z Shell Configuration
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
  };
}
