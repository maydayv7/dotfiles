{lib, ...}: {
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
}
