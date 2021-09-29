{ config, lib, pkgs, ... }:
{
  # Virtualization
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
