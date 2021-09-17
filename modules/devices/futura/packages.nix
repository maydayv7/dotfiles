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
    neofetch
    touchegg
    unzip
    unrar
    wget
    
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
    gnome.totem
  ];
  
  # Font Packages
  fonts.fonts = with pkgs; 
  [
      corefonts
      dejavu_fonts
      meslo-lgs-nf
      noto-fonts
      noto-fonts-emoji
      source-code-pro
      ubuntu_font_family
  ];
}
