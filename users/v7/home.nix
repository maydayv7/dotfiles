{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
in
{
  imports = [(import "${home-manager}/nixos")];
  
  # Home Configuration
  home-manager.users.v7 =
  {
    imports =
    [
      # Dconf Configuration
      ./modules/theme.nix
      ./modules/shortcuts.nix
      
      # User Program Configuration
      ./modules/programs.nix
    ];
    
    home =
    {
      # User Packages
      packages = with pkgs;
      [
        bluej
        calibre
        dconf2nix
        discord
        gscan2pdf
        megasync
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
        #gnomeExtensions.x11-gestures
      ];
      
      # Dotfiles
      file =
      {
        # Z Shell Prompt
        ".p10k.zsh".source = ./config/zsh-theme;
        
        # Neofetch Config
        ".config/neofetch/config.conf".source = ./config/neofetch;
        
        # X11 Gestures
        ".config/touchegg/touchegg.conf".source = ./config/gestures;
        
        # Custome GNOME Shell Theme
        ".themes/Adwaita/gnome-shell/gnome-shell.css".source = ./config/theme;
        
        # gEdit Color Scheme
        ".local/share/gtksourceview-4/language-specs/nix.lang".source = ./config/syntax;
        ".local/share/gtksourceview-4/styles/tango-dark.xml".source = ./config/colors;
        
        # Firefox GNOME Theme
        # https://github.com/rafaelmardojai/firefox-gnome-theme
        ".mozilla/firefox/v7/user.js".source = ./config/firefox/firefox-gnome-theme/configuration/user.js;
        ".mozilla/firefox/v7/chrome" =
        {
          source = ./config/firefox;
          recursive = true;
        };
        
        # Custom GNOME Extensions
        ".local/share/gnome-shell/extensions/top-bar-organizer@julian.gse.jsts.xyz" =
        {
          source = ./config/extensions/top-bar-organizer;
          recursive = true;
        };
        ".local/share/gnome-shell/extensions/x11gestures@joseexposito.github.io" =
        {
          source = ./config/extensions/x11-gestures;
          recursive = true;
        };
      };
    };
    
    # Overlays
    nixpkgs.overlays =
    [
      (import ./overlays/dash.nix)
    ];
  };
}
