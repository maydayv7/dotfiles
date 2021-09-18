{config, lib, pkgs, ... }:
{
  imports =
  [  
    # Keyboard Shortcuts
    ./shortcuts.nix
    
    # Apps and GNOME Shell Keys
    ./interface.nix
    
    # GNOME Shell Extensions Configuration
    ./extensions.nix
  ];
}
