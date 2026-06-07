# GPU configuration (NVIDIA)
## GPU Configuration ##
{ ... }:
{
  flake.modules.nixos.gpu =
    { config, options, lib, pkgs, ... }:
    let
      inherit (lib)
        mkForce
        mkIf
        mkEnableOption
        mkMerge
        mkOption
        types
        ;
      cfg = config.hardware.gpu;
      mode = config.hardware.cpu.mode != "powersave";
      gamemode = config.programs.gamemode.enable;
    in
    {
      options.hardware.gpu = {
        enable = mkEnableOption "Discrete GPU Support";
        model = mkOption {
          description = "Discrete GPU Model";
          type = with types; nullOr (enum [ "nvidia" ]);
          default = null;
        };
      };

      config = mkMerge [
        (mkIf cfg.enable {
          assertions = [
            {
              assertion = cfg.model != null;
              message = "GPU model must be set when GPU is enabled";
            }
          ];
        })

        (mkIf (cfg.enable && cfg.model == "nvidia") (
          let
            hybrid = with config.hardware.nvidia.prime; (amdgpuBusId != "" || intelBusId != "");
          in
          {
            services.xserver.videoDrivers = mkForce [ "nvidia" ];
            environment = {
              systemPackages = [ pkgs.btop-cuda ];
              variables = mkIf mode {
                "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
                "LIBVA_DRIVER_NAME" = "nvidia";
              };
              sessionVariables = {
                "GAMEMODERUNEXEC" = mkIf (hybrid && gamemode && !mode) "nvidia-offload";
              };
            };

            boot = {
              blacklistedKernelModules = [ "nouveau" ];
              kernelModules = [
                "nvidia"
                "nvidia_drm"
                "nvidia_modeset"
                "nvidia_uvm"
              ];
              kernelParams = [ "nvidia-drm.fbdev=1" ];
              # PAT Support
              # DDC/CI Support
              extraModprobeConfig = ''
                options nvidia NVreg_UsePageAttributeTable=1
                options nvidia NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100
              '';
            };

            # Wayland Support
            hardware.nvidia = {
              modesetting.enable = mkForce true;
              nvidiaSettings = mkForce true;
              dynamicBoost.enable = true;
              powerManagement.enable = true;
              prime = mkIf hybrid {
                sync.enable = mkForce mode;
                offload = {
                  enable = mkForce (!mode);
                  enableOffloadCmd = mkForce (!mode);
                };
              };
            };
          }
        ))

        (mkIf (!cfg.enable && cfg.model == "nvidia") {
          boot.blacklistedKernelModules = [
            "nvidia"
            "nvidia_drm"
            "nvidia_modeset"
            "nvidia_uvm"
          ];
        })
      ];
    };
}
