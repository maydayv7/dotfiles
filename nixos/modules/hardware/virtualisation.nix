# Virtualisation: KVM, libvirt, VFIO
## Virtualisation Settings ##
{ ... }:
{
  flake.modules = {
    nixos.virtualisation =
      { config, lib, pkgs, ... }:
      let
        inherit (config.hardware.cpu) model;
      in
      {
        environment.persist.directories = [ "/var/lib/libvirt" ];

        # Environment Setup
        security.virtualisation.flushL1DataCache = "cond";
        boot = {
          kernelModules = [ "kvm-${model}" ];
          extraModprobeConfig = "options kvm_${model} nested=1";
        };

        # VM Utilities
        programs.virt-manager.enable = true;
        # VM Packages
        environment.systemPackages = [ pkgs.libguestfs ];

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
              vhostUserPackages = [ pkgs.virtiofsd ];
            };
          };
        };
      };

    homeManager.virtualisation = { ... }: {
      home.persist.directories = [
        ".config/libvirt"
        ".local/share/libvirt"
      ];
    };
  };
}
