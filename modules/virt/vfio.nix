## VFIO Configuration ##
_: {
  flake.modules.nixos.vfio = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (builtins) concatStringsSep;
    inherit
      (lib)
      generators
      mkEnableOption
      mkForce
      mkIf
      mkMerge
      mkOption
      types
      ;
    cfg = config.virt.vfio;
    inherit (config.hardware.cpu) model;
  in {
    options.virt.vfio = {
      setup = mkEnableOption "VFIO Setup Mode";
      passthrough = mkOption {
        description = "PCI Device IDs for VFIO Passthrough";
        type = types.listOf types.str;
        default = [];
        example = [
          "10de:28e0" # Graphics
          "10de:22be" # Audio
        ];
      };
    };

    config = mkMerge [
      {
        specialisation.vfio.configuration = {
          system.nixos.label = "special.vfio";
          virt.vfio.setup = true;
          hardware.cpu.mode = mkForce "performance";
        };
      }

      (mkIf (!cfg.setup) {
        specialisation.no-vfio.configuration = {
          system.nixos.label = "special.no-vfio";
          virt.vfio.setup = false;
        };

        # Disable GPU
        hardware.gpu.enable = mkForce false;

        boot = {
          kernelParams = [
            "iommu=pt"
            "${model}_iommu=on"
            "kvm.ignore_msrs=1"
            "kvm.report_ignored_msrs=0"
            ("vfio-pci.ids=" + concatStringsSep "," cfg.passthrough)
          ];

          initrd.kernelModules = [
            "vfio"
            "vfio_pci"
            "vfio_iommu_type1"
          ];
        };

        # Looking Glass
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
  };
}
