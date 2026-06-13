### Boot

To boot into a different build generation, hold down the Spacebar (for `efi`) or the `Shift`/`Esc` key (for `mbr`) upon startup to access the boot menu

To access recovery settings, open the boot menu and select the `recovery` Specialisation

#### Secure Boot

Set `hardware.boot.loader` to `secure` to enable [Secure Boot](https://en.wikipedia.org/wiki/UEFI#Secure_Boot)

The setup should occur automatically on first boot, consult the [docs](https://nix-community.github.io/lanzaboote/) in case of any issue

> [!NOTE]
> Secure Boot is only supported in EFI Mode

### File System

The system may be set up using either a `simple` or `advanced` filesystem scheme. The advanced ZFS encrypted opt-in state filesystem configuration allows for a vastly improved experience, preventing formation of cruft and exerting total control over the device state, by erasing the system at every boot, keeping only what's required

#### Data Storage

All important persisted files are stored at `/data` (declared using either `hardware.fs.persist`, or `home.persist` for user files), while persisted system files are stored at `/nix/state` (declared using `environment.persist`).
Personal files and media are stored at `/data/files`

### Virtualisation

Configuration has been provided to run VMs using `qemu-kvm` and `libvirt`, along with support for VFIO PCI Passthrough. This can be used to create high-performance VMs, especially useful for virtualising Windows

#### PCI Passthrough

Use [`scripts/pci.sh`](../../scripts/pci.sh) in order to determine the PCI Device IDs which must be added to `hardware.vm.passthrough`

#### Windows Virtualisation

In order to create a highly performant Windows VM using the `virt-manager` GUI and [Virtio](https://wiki.libvirt.org/Virtio.html) drivers, follow the instructions given on [this](https://sysguides.com/install-a-windows-11-virtual-machine-on-kvm) page. To configure GPU passthrough, add the relevant GPU and audio IDs to `hardware.vm.passthrough` (See the [Arch Wiki](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF) for additional information), and set `hardware.vm.vfio` to `"on"`. Confirm that the GPU is recognized within the Windows VM, and download the relevant drivers. In order to utilize full graphical bandwidth, one of the following must be done:

1. Connect an external monitor to the GPU
2. Use a dummy monitor plug or fake a display using [`Virtual Display Driver`](https://github.com/itsmikethetech/Virtual-Display-Driver), then use [Looking Glass](https://looking-glass.io/) to extract video output onto the main monitor. The configuration for Looking Glass on the Linux (client) side is already implemented, and only the Windows (host) needs to be configured by following instructions on [this](https://looking-glass.io/docs/stable/install/) page (Follow the section titled 'IVSHMEM with shared memory')

The `vfio` Specialisation can be selected in the boot menu to enable GPU passthrough when required (when `hardware.vm.vfio` is set to `"setup"`)
