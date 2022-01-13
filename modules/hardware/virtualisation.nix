{ config, lib, pkgs, ... }:
let enable = (builtins.elem "virtualisation" config.hardware.support);
in rec {
  ## Virtualisation Settings ##
  config = lib.mkIf enable {
    # Virtualisation Enablement
    user.settings.extraGroups = [ "kvm" "libvirtd" ];
    filesystem.persist.directories = [ "/var/lib/libvirt" ];
    boot = {
      kernelModules = [ "kvm-intel" ];
      extraModprobeConfig = "options kvm_intel nested=1";
    };

    # VM Utilities
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu.runAsRoot = false;
      };
    };

    # VM Packages
    environment.systemPackages = [ pkgs.virt-manager ];
  };
}
