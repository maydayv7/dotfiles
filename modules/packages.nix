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
    
    # Utilities
    lolcat
    neofetch
    touchegg
    unzip
    unrar
    wget
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
