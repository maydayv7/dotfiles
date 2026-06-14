## Extended Base Configuration ##
{inputs, ...}: {
  flake.modules = {
    nixos.base-ext = _: {
      imports = [inputs.gaming.nixosModules.pipewireLowLatency];

      config = {
        # AppImage Support
        programs.appimage = {
          enable = true;
          binfmt = true;
        };

        # Documentation
        documentation = {
          dev.enable = true;
          man.enable = true;
        };

        # Low Latency Audio
        services.pipewire.lowLatency = {
          enable = true;
          quantum = 64;
          rate = 48000;
        };
      };
    };
  };
}
