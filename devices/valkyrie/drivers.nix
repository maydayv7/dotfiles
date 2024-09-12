{
  lib,
  pkgs,
  ...
}: {
  services.fwupd.enable = true;
  user.persist.directories = [".config/rog"];
  hardware = {
    vm.passthrough = ["10de:28e0" "10de:22be"];
    nvidia.prime = {
      nvidiaBusId = lib.mkForce "PCI:1:0:0";
      amdgpuBusId = lib.mkForce "PCI:65:0:0";
      sync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  systemd.services.mic-boost = {
    description = "Fix Internal Microphone";
    wantedBy = ["multi-user.target"];
    script = ''
      ${lib.getExe' pkgs.alsa-utils "amixer"} -c 2 sset 'Internal Mic Boost' 0
    '';
  };
}
