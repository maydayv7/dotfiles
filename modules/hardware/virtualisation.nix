{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep elem;
  inherit (lib) mkEnableOption mkIf mkOption types;
  enable = elem "virtualisation" config.hardware.support;
  cfg = config.hardware.vm;
in {
  options.hardware.vm = {
    android.enable = mkEnableOption "Enable Android Virtualisation";
    passthrough = mkOption {
      description = "PCI Device IDs for VM Passthrough";
      type = types.listOf types.str;
      default = [];
      example = ["00:02.0" "00:1c.0"];
    };
  };

  ## Virtualisation Settings ##
  config = mkIf enable {
    # Enablement
    user.groups = ["kvm" "libvirtd"];
    security.virtualisation.flushL1DataCache = "cond";
    boot = {
      kernelParams = ["intel_iommu=on" "i915.enable_gvt=1"];
      kernelModules = ["kvm-intel" "vfio" "vfio-pci" "vfio_virqfd" "vfio_iommu_type1"];
      extraModprobeConfig = ''
        options kvm_intel nested=1
        options vfio-pci ids=${concatStringsSep "," cfg.passthrough}
      '';
    };

    # VM Utilities
    virtualisation.kvmgt.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
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

    # Android Virtualisation
    virtualisation.waydroid = {inherit (cfg.android) enable;};

    # VM Packages
    environment.systemPackages = with pkgs;
      [libguestfs virt-manager]
      ++ (
        if cfg.android.enable
        then [wl-clipboard]
        else []
      );

    # File Persistence
    user.persist.dirs =
      [".config/libvirt" ".local/share/libvirt"]
      ++ (
        if cfg.android.enable
        then [".local/share/waydroid"]
        else []
      );
    environment.persist.dirs =
      ["/var/lib/libvirt"]
      ++ (
        if cfg.android.enable
        then ["/var/lib/waydroid"]
        else []
      );
  };
}
