{ config, lib, pkgs, ... }:
let
  inherit (builtins) concatStringsSep elem;
  inherit (lib) mkIf mkOption types;
  enable = elem "virtualisation" config.hardware.support;
in {
  options.hardware.passthrough = mkOption {
    description = "PCI Device IDs for VM Passthrough";
    type = types.listOf types.str;
    default = [ ];
  };

  ## Virtualisation Settings ##
  config = mkIf enable {
    # Enablement
    user.groups = [ "kvm" "libvirtd" ];
    user.persist.dirs = [ ".config/libvirt" ".local/share/libvirt" ];
    environment.persist.dirs = [ "/var/lib/libvirt" ];
    security.virtualisation.flushL1DataCache = "cond";
    boot = {
      kernelParams = [ "intel_iommu=on" "i915.enable_gvt=1" ];
      kernelModules =
        [ "kvm-intel" "vfio" "vfio-pci" "vfio_virqfd" "vfio_iommu_type1" ];
      extraModprobeConfig = ''
        options kvm_intel nested=1
        options vfio-pci ids=${concatStringsSep "," config.hardware.passthrough}
      '';
    };

    # VM Packages
    environment.systemPackages = with pkgs; [ libguestfs virt-manager ];

    # VM Utilities
    virtualisation = {
      kvmgt.enable = true;
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = false;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            package = pkgs.OVMFFull;
          };
        };
      };
    };
  };
}
