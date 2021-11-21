{ config, lib, pkgs, ... }:
let
  enable = config.hardware.virtualisation;
in rec
{
  options.hardware.virtualisation = lib.mkEnableOption "Enable Support for Virtualisation";

  ## Virtualisation Enablement ##
  config = lib.mkIf enable
  {
    boot =
    {
      kernelModules = [ "kvm-intel" ];
      extraModprobeConfig = "options kvm_intel nested=1";
    };

    virtualisation =
    {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    # VM Packages
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
