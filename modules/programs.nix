{ config, lib, pkgs, ... }:
{  
  # Network Management
  networking =
  {
    networkmanager.enable = true;
    firewall.enable = false;
    hostName = "Vortex"; 
  };
  
  # Font Configuration
  fonts =
  {
    enableDefaultFonts = true;
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
  };
  
  # Virtualization
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # Desktop Integration
  programs.dconf.enable = true;
  xdg =
  {
    portal =
    {
      enable = true;
      extraPortals = with pkgs; 
      [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };
  
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
  
  # X11 SSH Password Auth
  programs.ssh.askPassword = "";
}
