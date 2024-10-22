### Boot

To boot into a different build generation, hold down the Spacebar (for `efi`) or the `Shift`/`Esc` key (for `mbr`) upon startup to access the boot menu

To access recovery settings, open the boot menu and select the `recovery` Specialisation

#### Secure Boot

To configure Secure Boot, first install the system by using the `efi` loader, then follow [these](https://github.com/nix-community/lanzaboote/blob/v0.3.0/docs/QUICK_START.md) instructions and set `hardware.boot.loader` to `secure`

_If the `advanced` filesystem scheme is used, the keys need to be created after `/etc/secureboot` is persisted_

> [!NOTE]
> Secure Boot is only supported in EFI Mode

### File System

The system may be set up using either a `simple` or `advanced` filesystem layout. The advanced ZFS encrypted opt-in state filesystem configuration allows for a vastly improved experience, preventing formation of cruft and exerting total control over the device state, by erasing the system at every boot, keeping only what's required

#### Data Storage

All important, persisted user files are stored at `/data`, while persisted system files are stored at `/nix/state`. Personal files and media are stored at `/data/files`

### Virtualisation

Configuration has been provided to run VMs using `qemu-kvm` and `libvirt`, along with support for VFIO PCI Passthrough. This can be used to create high-performance VMs, especially useful for virtualising Windows

#### PCI Passthrough

Use [`scripts/pci.sh`](../../scripts/pci.sh) in order to determine the PCI Device IDs which must be added to `hardware.vm.passthrough`

#### Windows Virtualisation

In order to create a highly performant Windows VM using the `virt-manager` GUI and [Virtio](https://wiki.libvirt.org/Virtio.html) drivers, follow the instructions given on [this](https://sysguides.com/install-a-windows-11-virtual-machine-on-kvm) page. To configure GPU passthrough, add the relevant GPU and audio IDs to `hardware.vm.passthrough` (See the [Arch Wiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF) for additional information), and enable `hardware.vm.vfio`. Confirm that the GPU is recognized within the Windows VM, and download the relevant drivers. In order to utilize full graphical bandwidth, one of the following must be done:

1. Connecting an external monitor to the GPU
2. Using a dummy monitor plug or faking a display using [`Virtual Display Driver`](https://github.com/itsmikethetech/Virtual-Display-Driver), then using [Looking Glass](https://looking-glass.io/) to extract video output onto the main monitor. The configuration for Looking Glass on the Linux (client) side is already implemented, and only the Windows (host) needs to be configured by following instructions on [this](https://looking-glass.io/docs/stable/install/) page

The `vfio` Specialisation can be selected in the boot menu to enable GPU passthrough when required
