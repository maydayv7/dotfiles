## Dual Boot Layout
{config, ...}: {
  nixos = {lib, ...}: let
    inherit (lib) mkForce;
    inherit (config.flake.files) path;
    windows = "${path.data}/windows";
  in {
    # Filesystem
    system.fs = {
      scheme = "advanced";
      disk = "/dev/disk/by-id/nvme-eui.00000000000000000026b7686ab56005";
    };

    # Bypass Disko
    disko.devices.disk = mkForce {};

    # Boot Loader
    boot = {
      loader.timeout = mkForce 5;
      lanzaboote.settings.default = mkForce "auto-windows";
      zfs.devNodes = mkForce "/dev/disk/by-partlabel/NixOS";
    };

    # Zram SWAP
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 17;
    };

    # Shared ESP
    fileSystems."/boot" = {
      device = "/dev/disk/by-partuuid/5564bc59-d0ed-477b-b7db-47df192845b0";
      fsType = "vfat";
      options = ["umask=0077"];
    };

    # Windows Partition
    fileSystems."${windows}" = {
      device = "/dev/disk/by-partuuid/83b4b77c-c23a-4ae7-9609-9cae7cd1b06d";
      fsType = "ntfs3";
      options = ["rw" "nofail" "x-systemd.device-timeout=10s" "uid=1000" "gid=100" "dmask=022" "fmask=133"];
    };

    fileSystems."${path.files}" = {
      device = "${windows}/Files";
      fsType = "none";
      depends = [windows];
      options = ["bind" "nofail"];
    };

    # System Clock
    time.hardwareClockInLocalTime = true;
  };
}
