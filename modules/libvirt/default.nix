{ config, lib, pkgs, ... }:
{
  # Virtualization
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  environment.systemPackages = with pkgs;
  [
    virt-manager
  ];
}
