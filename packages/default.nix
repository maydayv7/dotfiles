{ pkgs, ... }:
with pkgs;
{
  custom =
  {
    # Custom Fonts
    product-sans = callPackage ./product-sans.nix {};
  };
}
