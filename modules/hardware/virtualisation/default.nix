{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep elem;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  enable = elem "virtualisation" config.hardware.support;
  cfg = config.hardware.vm;
in {
  imports = [./android.nix];

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

  ## Virtualisation Settings ##
  config = mkIf enable (mkMerge [
    {
      # Environment Setup
      user.groups = ["kvm" "libvirtd"];
      user.persist.directories = [".config/libvirt" ".local/share/libvirt"];
      environment.persist.directories = ["/var/lib/libvirt"];
      security.virtualisation.flushL1DataCache = "cond";
      specialisation.vfio.configuration.hardware.vm.vfio = true;
      boot = {
        kernelModules = ["kvm-amd" "kvm-intel"];
        extraModprobeConfig = ''
          options kvm_intel nested=1
        '';
      };

      # VM Packages
      environment.systemPackages = with pkgs; [libguestfs virtiofsd];
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
              packages = [pkgs.OVMFFull.fd];
            };
          };
        };
      };
    }
    (mkIf cfg.vfio {
      # VFIO Configuration
      system.nixos.tags = ["vfio"];
      boot = {
        kernelParams = [
          "amd_iommu=on"
          "intel_iommu=on"
          "i915.enable_gvt=1"
          ("vfio-pci.ids=" + concatStringsSep "," cfg.passthrough)
        ];

        kernelModules = [
          "vfio"
          "vfio-pci"
          "vfio_virqfd"
          "vfio_iommu_type1"
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
      };
    })
  ]);
}
