## Windows VM
# ? # Run 'virsh -c qemu:///system start windows'
{
  config,
  inputs,
  ...
}: let
  files = config.flake.files.path.files;
in {
  nixos = {
    config,
    pkgs,
    ...
  }: let
    vfio = !config.virt.vfio.setup;
    template = pkgs.writeText "windows-template.xml" (
      builtins.replaceStrings ["@files"] [files]
      (builtins.readFile ./windows.xml)
    );

    conf-vfio =
      pkgs.runCommand "windows.xml" {
        nativeBuildInputs = [pkgs.xmlstarlet];
      } ''
        xmlstarlet ed \
          -u '/domain/os/loader' -x 'normalize-space(.)' \
          -u '/domain/os/nvram' -x 'normalize-space(.)' \
          ${template} > "$out"
      '';

    conf-desktop =
      pkgs.runCommand "windows-desktop.xml" {
        nativeBuildInputs = [pkgs.xmlstarlet];
      } ''
        xmlstarlet ed -N qemu='http://libvirt.org/schemas/domain/qemu/1.0' \
          -d '/domain/memoryBacking/hugepages' \
          -s '/domain/memoryBacking' -t elem -n source -v "" \
          -i '/domain/memoryBacking/source' -t attr -n type -v memfd \
          -d '/domain/cputune' \
          -d "/domain/devices/hostdev[@type='pci']" \
          -s "/domain/devices/graphics[@type='spice']" -t elem -n mouse -v "" \
          -i "/domain/devices/graphics[@type='spice']/mouse" -t attr -n mode -v server \
          -d '/domain/qemu:commandline' \
          ${conf-vfio} > "$out"
      '';
  in {
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
        size = "256G";
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
            definition =
              if vfio
              then conf-vfio
              else conf-desktop;
            active = null;
            restart = false;
          }
        ];
      };
    };
  };
}
