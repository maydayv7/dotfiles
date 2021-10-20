{ config, lib, pkgs, ... }:
{
  ## Virtualization Enablement ##
  virtualisation =
  {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  # VM Packages
  environment.systemPackages = with pkgs; [ virt-manager ];
}
