### Virtual Machines
The `vm` directory contains the declarative configurations to build multiple Virtual Machines

Virtualisation is done using `qemu-kvm` and `libvirt`. Preferred GUI is `virt-manager`. For VFI/O, you can use `hardware.passthrough` to specify the devices you want to pass through to the VM (you can use [`scripts/pci.sh`](../../scripts/pci.sh) to find the IDs)

A [Windows](./Windows.nix) VM is declaratively installed and configured making use of the [WFVM](https://git.m-labs.hk/M-Labs/wfvm) Project. Use `nix build github:maydayv7/dotfiles#vmConfigurations.Windows` to build the image