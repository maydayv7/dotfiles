{lib, ...}: {
  services.fwupd.enable = true;
  hardware.nvidia.prime = {
    nvidiaBusId = lib.mkForce "PCI:1:0:0";
    amdgpuBusId = lib.mkForce "PCI:65:0:0";

    sync.enable = false;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
