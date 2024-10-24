{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep elem;
  inherit (lib) generators mkEnableOption mkForce mkIf mkMerge mkOption optionals types;
  enable = elem "virtualisation" config.hardware.support;
  cfg = config.hardware.vm;
in {
  options.hardware.vm = {
    vfio = mkEnableOption "Configure VFIO PCI passthrough";
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
  config = mkMerge [
    (mkIf enable {
      specialisation.vfio.configuration = {
        system.nixos.label = "special.vfio";
        hardware = {
          vm.vfio = true;
          cpu.mode = mkForce "performance";
        };
      };
    })

    (mkIf (enable && cfg.vfio) {
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
          # GPU Passthrough
          ++ optionals (elem "nvidia" config.services.xserver.videoDrivers) [
            "nvidia"
            "nvidia_modeset"
            "nvidia_uvm"
            "nvidia_drm"
          ];
      };

      # Looking Glass
      user.groups = ["kvm" "libvirtd" "qemu-libvirtd"];
      systemd.tmpfiles.rules = ["f /dev/shm/looking-glass 0660 root qemu-libvirtd -"];
      environment = {
        systemPackages = [pkgs.looking-glass-client];
        etc."looking-glass-client.ini".text = generators.toINI {} {
          app.renderer = "egl";
          win = {
            title = "Virtual Machine";
            autoResize = "yes";
            borderless = "no";
            dontUpscale = "yes";
            fullScreen = "no";
            keepAspect = "yes";
            maximize = "no";
            noScreensaver = "yes";
            quickSplash = "yes";
            uiSize = 16;
          };

          egl = {
            scale = 2;
            multisample = "yes";
            vsync = "yes";
          };

          input = {
            autoCapture = "yes";
            grabKeyboardOnFocus = "yes";
            rawMouse = "yes";
            releaseKeysOnFocusLoss = "yes";
          };

          spice = {
            enable = "yes";
            clipboard = "yes";
          };

          wayland = {
            warpSupport = "yes";
            fractionScale = "no";
          };
        };
      };
    })
  ];
}
