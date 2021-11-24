{ config, lib, pkgs, ... }:
let
  enable = (builtins.elem "virtualisation" config.hardware.support);
in rec
{
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
