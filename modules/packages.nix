{ config, lib, pkgs, ... }:
{
  # Apps and Games
  environment.systemPackages = with pkgs;
  [
    # Productivity
    celluloid
    google-chrome
    libreoffice
    lollypop
    
    # Utilities
    lolcat
    neofetch
    touchegg
    unzip
    unrar
    wget
    
    # GNOME Apps
    gnome.dconf-editor
    gnome.gnome-boxes
    gnome.gnome-dictionary
    gnome.gnome-notes
    gnome.gnome-sound-recorder
    gnome.gnome-todo
    gnome.gnome-tweaks
    gnome.polari
    
    # GNOME Games
    gnome.gnome-chess
    gnome.gnome-mines
    gnome.gnome-sudoku
    gnome.quadrapassel
    
    
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
  
  # Excluded GNOME Packages
  environment.gnome.excludePackages = with pkgs;
  [
    gnome.gnome-music
    gnome.totem
  ];
  
  # Font Packages
  fonts.fonts = with pkgs; 
  [
      corefonts
      dejavu_fonts
      fira
      fira-code
      fira-mono
      freefont_ttf
      hack-font
      meslo-lgs-nf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro
      ubuntu_font_family
  ];
}
