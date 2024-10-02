{
  config,
  lib,
  util,
  pkgs,
  ...
}: let
  enable = builtins.elem "virtualisation" config.hardware.support;
in {
  imports = util.map.modules.list ./.;

  ## Virtualisation Settings ##
  config = lib.mkIf enable {
    # Environment Setup
    user.groups = ["kvm" "libvirtd"];
    user.persist.directories = [".config/libvirt" ".local/share/libvirt"];
    environment.persist.directories = ["/var/lib/libvirt"];
    security.virtualisation.flushL1DataCache = "cond";
    boot = {
      kernelModules = ["kvm-amd" "kvm-intel"];
      extraModprobeConfig = "options kvm_intel nested=1";
    };

    # VM Packages
    environment.systemPackages = with pkgs; [libguestfs virtiofsd];
    programs.virt-manager.enable = true;

    #!# Run 'virsh net-start default' to start network service

    # VM Utilities
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
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
        };
      };
    };
  };
}
