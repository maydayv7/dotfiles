## Full Disk Layout
_: {
  nixos = _: {
    system.fs = {
      scheme = "advanced";
      disk = "/dev/disk/by-id/nvme-eui.00000000000000000026b7686ab56005";
      swap = "8G";
    };
  };
}
