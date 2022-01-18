{ config, lib, pkgs, ... }:
let
  enable = builtins.elem "virtualisation" config.hardware.support;
  inherit (config.hardware) passthrough;
in rec {
  options.hardware.passthrough = lib.mkOption {
    description = "PCI Device IDs for VM Passthrough";
    type = lib.types.str;
    default = "";
  };

  ## Virtualisation Settings ##
  config = lib.mkIf enable {
    # Enablement
    user.settings.extraGroups = [ "kvm" "libvirtd" ];
    filesystem.persist.directories = [ "/var/lib/libvirt" ];
    boot = {
      kernelParams = [ "intel_iommu=on" "i915.enable_gvt=1" ];
      kernelModules =
        [ "kvm-intel" "vfio" "vfio-pci" "vfio_virqfd" "vfio_iommu_type1" ];
      extraModprobeConfig = ''
        options kvm_intel nested=1
        options vfio-pci ids=${passthrough}
      '';
    };

    # VM Utilities
    virtualisation = {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          runAsRoot = false;
          ovmf.enable = true;
        };
      };
    };

    # VM Packages
    environment.systemPackages = with pkgs; [ libguestfs virt-manager ];
  };
}
