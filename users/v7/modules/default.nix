{config, lib, pkgs, ... }:
{
  imports =
  [
    # Dotfiles
    ./dotfiles.nix
    
    # Theme Configuration
    ./theme.nix
    
    # User Package List
    ./packages.nix
    
    # User Program Configuration
    ./programs.nix
    
    # Dconf Configuration    
    ./shortcuts.nix  # Keyboard Shortcuts
    ./interface.nix  # Apps and GNOME Shell Keys
    ./extensions.nix # GNOME Shell Extensions Configuration
  ];
}
