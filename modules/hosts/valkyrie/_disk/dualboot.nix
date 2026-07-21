## Dual Boot Layout
{config, ...}: {
  nixos = {lib, ...}: let
    inherit (config.flake) files;
    inherit (lib) mkForce;
  in {
    # Filesystem
    system.fs = {
      scheme = "advanced";
      disk = "/dev/disk/by-id/nvme-eui.00000000000000000026b7686ab56005";
    };

    # Bypass Disko
    disko.devices.disk.main = mkForce {};

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
      memoryPercent = 25;
    };

    # Shared ESP
    fileSystems."/boot" = {
      device = "/dev/disk/by-partuuid/4fdd8116-b999-4dab-97a6-bb56e99e0635";
      fsType = "vfat";
      options = ["umask=0077"];
    };

    # Windows Partition
    fileSystems."${files.path.data}/windows" = {
      device = "/dev/disk/by-label/System";
      fsType = "ntfs3";
      options = ["rw" "nofail" "uid=1000" "gid=100" "dmask=022" "fmask=133"];
    };

    fileSystems."${files.path.files}" = {
      device = "${files.path.data}/windows/Files";
      fsType = "none";
      options = ["bind"];
    };

    fileSystems."${files.path.sync}" = {
      device = "${files.path.data}/windows/Files/Sync";
      fsType = "none";
      options = ["bind"];
    };

    # System Clock
    time.hardwareClockInLocalTime = true;
  };
}
