{ config, lib, pkgs, ... }:
{  
  # Virtualization
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # GPG Key Signing
  programs.gnupg.agent =
  {
    enable = true;
    pinentryFlavor = "gnome3";
  };
  
  # X11 SSH Password Auth
  programs.ssh.askPassword = "";
}
