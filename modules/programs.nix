{ config, lib, pkgs, ... }:
{
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
  };
  nixpkgs =
  {
    # Package Overlays
    overlays = (import ../overlays);
    config =
    {
      allowUnfree = true;
      packageOverrides = pkgs:
      {
        # Additional Repos
        nur = import (import ../../volatile/repos/nur.nix) { inherit pkgs; };
        unstable = import (import ../../volatile/repos/unstable.nix) { inherit pkgs; };
      };
    };
  };
  
  # Network Management
  networking =
  {
    networkmanager.enable = true;
    firewall.enable = false;
  };
  
  # Font Configuration
  fonts =
  {
    enableDefaultFonts = true;
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
  };
  
  # Security Settings
  security =
  {
    sudo.extraConfig =
    "
      Defaults pwfeedback
    ";
  };
  
  # Desktop Integration
  programs.dconf.enable = true;
  services =
  {
    dbus.packages = [ pkgs.gnome.dconf ];
    udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
    gnome =
    {
      chrome-gnome-shell.enable = true;
      gnome-keyring.enable = true;
      gnome-remote-desktop.enable = true;
    };
  };
  
  # GPG Key Signing
  programs.gnupg.agent =
  {
    enable = true;
    pinentryFlavor = "gnome3";
  };
  
  # X11 SSH Password Auth
  programs.ssh.askPassword = "";
  
  # Touchegg X11 Gestures
  systemd.services.touchegg =
  {
    enable = true;
    description = "The daemon for Touchégg X11 Gestures.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = 
    {
      Type = "simple";
      Group = "input";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = "${pkgs.touchegg}/bin/touchegg --daemon";
    };
  };
}
