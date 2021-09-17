{ config, lib, pkgs, ... }:
{  
  # Virtualization
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # X11 SSH Password Auth
  programs.ssh.askPassword = "";
}
