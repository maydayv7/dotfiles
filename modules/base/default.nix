{
  config,
  options,
  lib,
  util,
  inputs,
  pkgs,
  ...
}: let
  inherit (builtins) attrNames map;
  inherit (lib) removePrefix mkOption optionals types;
  cfg = config.base;
in {
  imports = util.map.modules.list ./. ++ [inputs.generators.nixosModules.all-formats];

  options.base = {
    kernel = mkOption {
      description = "Linux Kernel Variant to be used";
      default = "zfs";
      type = types.enum (
        ["lts" "zfs"]
        ++ (map (name: removePrefix "linux_" name) (attrNames pkgs.linuxKernel.kernels))
      );
    };

    kernelModules = mkOption {
      description = "Linux Kernel Modules to load";
      type = with types; listOf str;
      default = [];
    };
  };

  ## Base Configuration ##
  config = {
    # Kernel Configuration
    boot = {
      supportedFilesystems = optionals (cfg.kernel == "zfs") ["zfs"];
      kernelPackages =
        if (cfg.kernel == "zfs")
        then pkgs.zfs.latestCompatibleLinuxPackages
        else if (cfg.kernel == "lts")
        then options.boot.kernelPackages.default
        else pkgs.linuxKernel.packages."${"linux_" + cfg.kernel}";

      initrd.availableKernelModules =
        optionals (cfg.kernelModules != [])
        (cfg.kernelModules ++ ["ahci" "sd_mod" "usbhid" "usb_storage" "xhci_pci"]);
    };

    # Documentation
    documentation = {
      dev.enable = true;
      man.enable = true;
    };

    # Essential Utilities
    environment.systemPackages = with pkgs; [
      cryptsetup
      inxi
      killall
      man-pages
      mkpasswd
      ntfsprogs
      parted
      pciutils
      rsync
      sdparm
      smartmontools
      unrar
      unzip
      usbutils
      wget
    ];
  };
}
