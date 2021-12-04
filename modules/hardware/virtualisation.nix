{ config, lib, pkgs, ... }:
let
  enable = (builtins.elem "virtualisation" config.hardware.support);
in rec
{
  ## Virtualisation Settings ##
  config = lib.mkIf enable
  {
    # Virtualisation Enablement
    user.settings.extraGroups = [ "kvm" "libvirtd" ];
    boot =
    {
      kernelModules = [ "kvm-intel" ];
      extraModprobeConfig = "options kvm_intel nested=1";
    };

    # VM Utilities
    virtualisation =
    {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    # VM Packages
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
