## Libvirt Settings ##
_: {
  flake.modules = {
    nixos.libvirt = {
      config,
      pkgs,
      ...
    }: let
      inherit (config.hardware.cpu) model;
    in {
      # Environment Setup
      environment.persist.directories = ["/var/lib/libvirt"];
      security.virtualisation.flushL1DataCache = "cond";
      boot = {
        kernelModules = ["kvm-${model}"];
        extraModprobeConfig = "options kvm_${model} nested=1";
      };

      virtualisation = {
        kvmgt.enable = true;
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "shutdown";
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = false;
            swtpm.enable = true;
            vhostUserPackages = [pkgs.unstable.virtiofsd];
          };
        };
      };

      # VM Utilities
      programs.virt-manager.enable = true;
      environment.systemPackages = [pkgs.libguestfs];
    };

    homeManager.libvirt = _: {
      home.persist.directories = [
        ".config/libvirt"
        ".local/share/libvirt"
      ];
    };
  };
}
