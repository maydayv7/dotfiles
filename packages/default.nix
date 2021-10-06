{ pkgs, ... }:
with pkgs;
{
  custom =
  {
    # X11 Gestures
    touchegg = callPackage ./touchegg.nix {};
    
    # Custom Fonts
    product-sans = callPackage ./product-sans.nix {};
    
    # Custom GNOME Shell Extension
    dash-to-panel = callPackage ./dash-to-panel.nix {};
  };
}
