## Windows VM
# ? # Run 'virsh -c qemu:///system start windows'
{inputs}: {
  nixos = {pkgs, ...}: {
    imports = [inputs.nixvirt.nixosModules.default];

    disko.devices.zpool.fspool.datasets = {
      "vm" = {
        type = "zfs_fs";
        options = {
          canmount = "off";
          mountpoint = "none";
        };
      };
      "vm/windows" = {
        type = "zfs_volume";
        size = "128G";
        options = {
          volblocksize = "16k";
          refreservation = "none";
        };
      };
    };

    virtualisation.libvirt = {
      enable = true;
      package = pkgs.libvirt;
      connections."qemu:///system" = {
        networks = [
          {
            definition = ./default.xml;
            active = true;
          }
        ];

        domains = [
          {
            definition = ./windows.xml;
            active = null;
          }
        ];
      };
    };
  };
}
