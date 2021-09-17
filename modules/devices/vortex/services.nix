{ config, lib, pkgs, ... }:
{  
  # Virtualization
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # Desktop Integration
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
  
  # X11 SSH Password Auth
  programs.ssh.askPassword = "";
}
