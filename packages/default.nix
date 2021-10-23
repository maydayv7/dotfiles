{ inputs, pkgs, ... }:
with pkgs;
{
  ## Custom Self-Built Packages ##
  custom =
  {
    # Custom Fonts
    fonts = callPackage ./fonts.nix { };
    
    # User Credentials
    secrets = callPackage ./secrets.nix { inherit inputs; };
    
    # Firefox GNOME Theme
    gnome-firefox = callPackage ./firefox.nix { inherit inputs; };
  };
}
