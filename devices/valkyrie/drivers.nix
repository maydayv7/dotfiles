{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
  mode = config.hardware.cpu.mode == "performance";
in {
  user.persist.directories = [".config/rog"];
  services = {
    fwupd.enable = true;
    xserver.videoDrivers = mkForce ["nvidia"];
  };

  hardware = {
    vm.passthrough = ["10de:28e0" "10de:22be"];
    nvidia = {
      dynamicBoost.enable = true;
      prime = {
        nvidiaBusId = mkForce "PCI:1:0:0";
        amdgpuBusId = mkForce "PCI:101:0:0";
        sync.enable = mkForce mode;
        offload = {
          enable = mkForce (!mode);
          enableOffloadCmd = mkForce (!mode);
        };
      };
    };
  };

  user.homeConfig.home.file.".config/autostart/mic-boost.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=mic-boost
    Exec=${pkgs.writeShellApplication {
      name = "mic";
      text = "amixer -c 2 sset 'Internal Mic Boost' 0";
      runtimeInputs = with pkgs; [alsa-utils];
    }}/bin/mic
  '';
}
