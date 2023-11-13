{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep elem;
  inherit (lib) mkIf mkOption optionals types;
  enable = elem "virtualisation" config.hardware.support;
in {
  imports = [./android.nix];

  options.hardware.vm.passthrough = mkOption {
    description = "PCI Device IDs for VM Passthrough";
    type = types.listOf types.str;
    default = [];
    example = ["00:02.0" "00:1c.0"];
  };

  ## Virtualisation Settings ##
  config = mkIf enable {
    # Environment Setup
    user.groups = ["kvm" "libvirtd"];
    user.persist.directories = [".config/libvirt" ".local/share/libvirt"];
    environment.persist.directories = ["/var/lib/libvirt"];
    security.virtualisation.flushL1DataCache = "cond";
    boot = {
      kernelParams = ["intel_iommu=on" "i915.enable_gvt=1"];
      kernelModules = ["kvm-intel" "vfio" "vfio-pci" "vfio_virqfd" "vfio_iommu_type1"];
      extraModprobeConfig = ''
        options kvm_intel nested=1
        options vfio-pci ids=${concatStringsSep "," config.hardware.vm.passthrough}
      '';
    };

    # VM Packages
    environment.systemPackages = [pkgs.libguestfs];
    programs.virt-manager.enable = true;

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
            packages = [pkgs.OVMFFull];
          };
        };
      };
    };
  };
}
