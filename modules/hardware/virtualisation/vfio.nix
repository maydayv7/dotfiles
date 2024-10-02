{
  config,
  lib,
  ...
}: let
  inherit (builtins) concatStringsSep elem;
  inherit (lib) mkEnableOption mkForce mkIf mkOption optionals types;
  enable = elem "virtualisation" config.hardware.support;
  cfg = config.hardware.vm;
in {
  options.hardware.vm = {
    vfio = mkEnableOption "Configure the device for VFIO";
    passthrough = mkOption {
      description = "PCI Device IDs for VFIO";
      type = types.listOf types.str;
      default = [];
      example = [
        "10de:28e0" # Graphics
        "10de:22be" # Audio
      ];
    };
  };

  ## VFIO Configuration ##
  config = mkIf (enable && cfg.vfio) {
    specialisation.vfio.configuration.hardware = {
      vm.vfio = true;
      cpu.mode = mkForce "performance";
    };

    system.nixos.tags = ["vfio"];
    boot = {
      kernelParams = [
        "amd_iommu=pt"
        "intel_iommu=pt"
        "i915.enable_gvt=1"
        "iommu=pt"
        "kvm.ignore_msrs=1"
        "kvm.report_ignored_msrs=0"
        ("vfio-pci.ids=" + concatStringsSep "," cfg.passthrough)
      ];

      kernelModules =
        [
          "vfio"
          "vfio_pci"
          "vfio_iommu_type1"
          "vfio_virqfd"
        ]
        ++ optionals (elem "nvidia" config.services.xserver.videoDrivers) [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
    };
  };
}
