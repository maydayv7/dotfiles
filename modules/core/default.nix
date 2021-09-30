{ config, lib, pkgs, ... }:
let
  path = (builtins.readFile ../../src/path);
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  # Authentication Credentials
  imports = [ ../../secrets ];
  
  # User Management
  users.mutableUsers = false;
  nix.trustedUsers = [ "root" "v7" ];
  
  # Package Overrides
  nixpkgs.overlays = (import ../../overlays);
  
  # System Scripts
  environment.systemPackages = with pkgs; [ scripts.management ];
  
  # Nix Configuration
  nix =
  {
    autoOptimiseStore = true;
    # Garbage Collection
    gc =
    {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };
    # Flakes
    package = pkgs.nixUnstable;
    extraOptions =
    ''
      experimental-features = nix-command flakes
    '';
  };
  
  # Environment Configuration
  environment =
  {
    pathsToLink = [ "/share/zsh" ];
    variables =
    {
      EDITOR = "nano";
    };
    shells = with pkgs; [ bashInteractive zsh ];
    etc =
    {
      # Configuration Files
      "nixos".source = path;
    };
  };
  
  # Localization
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN.UTF-8";
  console =
  {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };
}
