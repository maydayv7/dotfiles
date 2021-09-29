{ config, lib, pkgs, ... }:
{
  # Git utilities
  environment.systemPackages = with pkgs;
  [
    git
    git-crypt
    unzip
    unrar
    wget
  ];
  # GPG Key Signing
  programs.gnupg.agent =
  {
    enable = true;
    pinentryFlavor = "gnome3";
  };
  
  # X11 SSH Password Auth
  programs.ssh.askPassword = "";
}
