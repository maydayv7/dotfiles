{ pkgs, ... }:
with pkgs;
{
  custom =
  {
    # Latest OnlyOffice Stable
    onlyoffice = callPackage ./onlyoffice.nix {};
    
    # X11 Gestures
    touchegg = callPackage ./touchegg.nix {};
    
    # Custom Fonts
    product-sans = callPackage ./product-sans.nix {};
    
    # Custom GNOME Shell Extension
    dash-to-panel = callPackage ./dash-to-panel.nix {};
  };
}
