+++
title = "Windows VM"
description = "A declarative, performant Windows 11 VM with dGPU passthrough and Looking Glass"
date = 2026-06-27

[taxonomies]
series = ["NixOS Desktop"]
tags = ["NixOS", "VFIO", "Virtualisation"]

[extra]
ToC = true
edit = true
comments = true
+++

# Intro

This is a guide to running a Windows 11 VM with an NVIDIA dGPU passed straight through to it, displayed via [Looking Glass](https://looking-glass.io/) directly on the primary display (no secondary monitor required), CPU-pinned and hugepage-backed for lower latency, and defined declaratively with [NixVirt](https://github.com/AshleyYakeley/NixVirt) - all on NixOS.

I run this on a laptop with an AMD Ryzen CPU, an integrated Radeon iGPU, and an NVIDIA RTX 4060. Any other host with 2 GPUs, or a dGPU + iGPU, should work the same way.

# Prerequisites

- CPU support for **IOMMU**
- A GPU you can dedicate to the VM that sits alone in its **own IOMMU group**. Check with:

  ```console
  $ for d in /sys/kernel/iommu_groups/*/devices/*; do
      echo "Group ${d%/devices/*}: $(lspci -nns ${d##*/})"; done | sort
  ```

  Find your GPU and note its `vendor:device` IDs:

  ```console
  $ lspci -nnk -s 01:00.0
  01:00.0 VGA compatible controller [0300]: NVIDIA ... [10de:28e0]
  01:00.1 Audio device [0403]: NVIDIA ... [10de:22be]
  ```

- Download ISOs:
  - **Windows 11** - Download from [Microsoft](https://www.microsoft.com/software-download/windows11).
  - **virtio-win** - The para-virtual Windows drivers: `nix build nixpkgs#virtio-win`

# Binding the GPU for VFIO

The core idea is to bind the GPU to the `vfio-pci` stub driver **at boot, before its real driver** kicks in. How you do that depends on your setup:

**Case A - the host renders on a _different_ GPU** (Eg. your desktop runs on the iGPU). Just bind the dGPU permanently:

```nix
boot.initrd.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
boot.kernelParams = [
  "amd_iommu=on" "iommu=pt"
  "vfio-pci.ids=10de:28e0,10de:22be" # your GPU + its audio function
];
```

**Case B - the host renders on the _same_ GPU you want to pass** (Eg. NVIDIA PRIME Sync, where the desktop holds `nvidia_drm`). A NixOS [specialisation](https://wiki.nixos.org/wiki/Specialisation) can be used: your default boot keeps the GPU for the desktop, and a different boot entry binds it to `vfio-pci` instead:

```
specialisation.vfio.configuration = {
  boot = {
    blacklistedKernelModules = [   # don't load host driver
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
   ];
    ...   # rest is same as above
  };
};
```

You reboot, pick the `vfio` entry , and reboot back to normal afterwards.

Either way, confirm after booting:

```console
$ lspci -nnk -s 01:00.0 | grep 'in use'
        Kernel driver in use: vfio-pci
```

_Dynamic GPU passthrough (w/o reboot) is possible, but is cumbersome and comes with its own set of drawbacks_

# Building the VM

First, enable libvirt/QEMU on the host. The essentials are `libvirtd` itself, `swtpm` (the software TPM that Windows 11 requires), SPICE USB redirection, and `virt-manager` to drive it all - plus adding your user to the `libvirtd` and `kvm` groups so you can manage VMs and open `/dev/kvm` without `sudo`:

```
{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  users.users.<you>.extraGroups = [ "libvirtd" "kvm" ];
}
```

The guest disk should be a raw block device or image (rather than an emulated SATA disk) for performance. I back it with a sparse ZFS zvol (a `qcow2` file works just as well):

```console
$ sudo zfs create -s -V 120G -o volblocksize=16k <pool>/vm/windows
# appears as /dev/zvol/<pool>/vm/windows
```

Now create a standard Windows 11 guest (`virt-manager` makes this easy, you may refer to [**this guide**](https://sysguides.com/install-a-windows-11-virtual-machine-on-kvm)). The settings that matter:

- **Q35** chipset + **UEFI/OVMF** with **Secure Boot**, and **TPM 2.0** (`swtpm`) - Windows 11 requires the latter two.
- **`host-passthrough`** CPU.
- **virtio everywhere** - disk (on the zvol above) with `cache=none`, `io=native`, `discard=unmap`; virtio NIC (for performance).
- **Hyper-V enlightenments** so Windows uses its kernel fast paths.
- A **QEMU guest agent** channel.

On AMD, in the Hyper-V block, omit `<evmcs/>` - that enlightenment is Intel-only and the VM won't start with it. A good set:

```xml
<hyperv mode="custom">
  <relaxed state="on"/> <vapic state="on"/> <spinlocks state="on" retries="8191"/>
  <vpindex state="on"/> <runtime state="on"/> <synic state="on"/> <stimer state="on"/>
  <frequencies state="on"/> <tlbflush state="on"/> <ipi state="on"/> <avic state="on"/>
</hyperv>
```

Since the disk is virtio, the Windows installer won't see it until you **Load driver** from the mounted `virtio-win.iso` (`viostor\w11\amd64`, then `NetKVM` for network). After install, run `virtio-win-guest-tools` for the rest. Finally, add the GPU (and its audio function) as PCI host devices.

# Looking Glass

A passed-through GPU usually has no monitor attached, so [Looking Glass](https://looking-glass.io/) captures the guest framebuffer and passes it through a shared-memory device into a client window on the NixOS host, with very low latency.

The transport is the `kvmfr` kernel module, which exposes `/dev/kvmfr0`:

```nix
boot = {
  extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  kernelModules = [ "kvmfr" ];
  extraModprobeConfig = "options kvmfr static_size_mb=64";
};

# Add your user to the 'kvm' group to open the device
services.udev.extraRules = ''
  SUBSYSTEM=="kvmfr", KERNEL=="kvmfr0", MODE="0660", GROUP="kvm", TAG+="systemd"
'';

environment.systemPackages = [ pkgs.looking-glass-client ];
```

Give the VM the matching `ivshmem` device via a `<qemu:commandline>` block that points `mem-path` at `/dev/kvmfr0` (this needs `xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'` on the root `<domain>` tag):

```xml
<qemu:commandline>
  <qemu:arg value='-device'/>
  <qemu:arg value='ivshmem-plain,id=shmem0,memdev=looking-glass,bus=pcie.0,addr=0x0a'/>
  <qemu:arg value='-object'/>
  <qemu:arg value='memory-backend-file,id=looking-glass,mem-path=/dev/kvmfr0,size=67108864,share=yes'/>
</qemu:commandline>
```

Inside Windows, install the following:

1. **NVIDIA driver** - Automatic via Windows Update.
2. **A virtual display driver** ([MikeTheTech's VDD](https://github.com/VirtualDrivers/Virtual-Display-Driver)) - gives the desktop a head to render on. Its config (`C:\VirtualDisplayDriver\vdd_settings.xml`) can pin the virtual display to a specific GPU and define exact modes, so bind it to the passed-through GPU at your native resolution:

   ```xml
   <vdd_settings>
     <monitors><count>1</count></monitors>
     <gpu><friendlyname>NVIDIA GeForce RTX 4060 Laptop GPU</friendlyname></gpu>
     <resolutions>
       <resolution><width>2560</width><height>1600</height><refresh_rate>165</refresh_rate></resolution>
     </resolutions>
   </vdd_settings>
   ```

3. **Looking Glass (host)** - its build **must match the client build exactly**. Its installer also provides the IVSHMEM driver for the "PCI standard RAM Controller" device in Device Manager. Install it as a **service** (`looking-glass-host.exe InstallService`) rather than launching it interactively - the service can capture the secure desktop, so UAC prompts don't black out the stream, and it starts at boot on its own.

Then run `looking-glass-client` on the host, and a full-resolution Windows desktop appears in a window, GPU-accelerated, captured off the GPU framebuffer over DirectX 12. Keyboard, mouse and clipboard ride back over SPICE.

# Performance tuning

The values below (which cores, how many hugepages) are **machine-specific** - compute them from your own topology.

## CPU pinning

By default the scheduler shuffles vCPUs across host threads and runs QEMU's emulator/IO threads on top of them, which shows up as frame-time spikes.
Pin each guest vCPU to a fixed host thread, matching SMT siblings, and push the emulator/IO threads onto separate housekeeping cores.
Find your sibling pairs first:

```console
$ cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list
```

For a 6-vCPU guest whose host has siblings `N`/`N+8`, mapping three physical cores (2, 3, 4) and keeping cores 0–1 for the host:

```xml
<vcpu placement='static'>6</vcpu>
<iothreads>1</iothreads>
<cputune>
  <vcpupin vcpu='0' cpuset='2'/>  <vcpupin vcpu='1' cpuset='10'/>  <!-- core 2 -->
  <vcpupin vcpu='2' cpuset='3'/>  <vcpupin vcpu='3' cpuset='11'/>  <!-- core 3 -->
  <vcpupin vcpu='4' cpuset='4'/>  <vcpupin vcpu='5' cpuset='12'/>  <!-- core 4 -->
  <emulatorpin cpuset='0-1,8-9'/>
  <iothreadpin iothread='1' cpuset='0-1,8-9'/>
</cputune>
```

Assign that iothread to the virtio disk so storage interrupts stay off the cores:

```xml
<driver name='qemu' type='raw' cache='none' io='native' discard='unmap' iothread='1'/>
```

## Core isolation

Pinning chooses which host threads the guest uses - isolating those cores stops the host from scheduling its own work there.
If your passthrough lives in a dedicated boot entry, scope the isolation to it so it costs nothing during normal use:

```nix
boot.kernelParams = [
  "isolcpus=2-4,10-12"
  "nohz_full=2-4,10-12"
  "rcu_nocbs=2-4,10-12"
];
```

## Hugepages

Backing the guest RAM with 1 GiB hugepages reduces TLB misses and the cost of memory virtualisation (more about latency consistency than throughput).
Reserve them at boot - and since they're held exclusively, this is another good thing to scope to the boot entry:

```nix
boot.kernelParams = [ "default_hugepagesz=1G" "hugepagesz=1G" "hugepages=16" ]; # 16 GiB
```

Request them in the domain, and drop the memory balloon (it fights fixed hugepage-backed RAM):

```xml
<memoryBacking><hugepages><page size='1048576' unit='KiB'/></hugepages></memoryBacking>
...
<memballoon model='none'/>
```

> [!NOTE]
> Keep these in sync: the `<cputune>` cpuset must match `isolcpus`, and the hugepage count must match the guest's RAM.

## Other tweaks

Run the host CPU governor at `performance` (`powerManagement.cpuFreqGovernor = "performance"`). Inside Windows, a few standard tweaks help:

- `bcdedit /set useplatformclock No` - with Hyper-V enlightenments on, leaving it enabled hurts performance.
- Disable **SysMain / SuperFetch**, set **Visual Effects → best performance**, and disable **ScheduledDefrag** (never defrag a virtio disk).

# Declarative Domain configuration

[NixVirt](https://github.com/AshleyYakeley/NixVirt) manages libvirt domains from Nix and accepts an XML file directly:

```nix
{ inputs, pkgs, ... }: {
  imports = [ inputs.nixvirt.nixosModules.default ];
  virtualisation.libvirt = {
    enable = true;
    package = pkgs.libvirt;
    connections."qemu:///system".domains = [
      {
        definition = ./windows.xml;
        active = null;
      }
    ];
  };
}
```

`active = null` is important: NixVirt redefines the domain on every rebuild but never starts, stops or destroys a running guest.

If you use **impermanence** (an erase-on-boot root), the domain definition is now regenerated from Nix, so you only need to persist the actual state. Two directories matter:

```nix
environment.persist.directories = [
  "/var/lib/libvirt" # NVRAM, swtpm state, networks
  "/var/lib/systemd" # Host key that decrypts libvirt's secrets
];
```

Also ensure the disk image itself is persisted.

# Networking

The virtio NIC on libvirt's default network gives the guest internet through NAT out of the box. Just run the following command once:

```console
$ virsh -c qemu:///system net-autostart default
```

# File sharing

[virtiofs](https://virtio-fs.gitlab.io/) shares a host directory straight into the guest over a shared-memory transport - much faster than SMB.
Point a `<filesystem>` device at the host path and give it a tag:

```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs' queue='1024'/>
  <source dir='/data/files'/>
  <target dir='Files'/>
</filesystem>
```

The device needs access to guest RAM, so the memory backing must be **shared**:

```xml
<memoryBacking>
  <hugepages><page size='1048576' unit='KiB'/></hugepages>
  <access mode='shared'/>
</memoryBacking>
```

Host-side, libvirt spawns the `virtiofsd` daemon - just hand it the package:

```nix
virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
```

Inside Windows, the `virtio-win-guest-tools` installer ships the **VirtIO-FS** driver and the `VirtioFsSvc` service. You must additionally install [WinFSP](https://winfsp.dev/) - the user-mode filesystem layer it depends on, then start the service so it mounts (set it to Automatic so it survives reboots):

```console
> sc start VirtioFsSvc
```

# USB passthrough

For an **ad-hoc** device, `virt-manager` is the easiest route: open the running guest, _Add Hardware → USB Host Device_, pick it from the list, and it's hot-plugged into Windows. SPICE USB redirection is also enabled, so the _Redirect USB Device_ menu option can be used as well.

For something you want **always** attached - say a webcam - bind it by USB ID in the domain instead. Find it with `lsusb`:

```console
$ lsusb
Bus 003 Device 002: ID 3277:0018 Sonix Technology Co., Ltd. USB2.0 FHD UVC WebCam
```

Then add a USB `<hostdev>`:

```xml
<hostdev mode='subsystem' type='usb' managed='yes'>
  <source>
    <vendor id='0x3277'/>
    <product id='0x0018'/>
  </source>
</hostdev>
```

# Useful commands

Run as your user (in the `libvirtd` + `kvm` groups, no `sudo` needed):

```console
$ virsh -c qemu:///system list --all
$ virsh -c qemu:///system start    windows
$ virsh -c qemu:///system shutdown windows --mode=agent   # Clean shutdown
$ virsh -c qemu:///system destroy  windows                # Force off
$ virsh -c qemu:///system net-dhcp-leases default         # Guest IP

# Peek at the guest headlessly
$ virsh -c qemu:///system screenshot windows --file /tmp/vm.ppm
$ nix shell nixpkgs#imagemagick -c magick /tmp/vm.ppm /tmp/vm.png
```

# Wrapping up

You may refer to my own [configuration](https://github.com/maydayv7/dotfiles), which sets up all of the above (on the host `valkyrie`), if you'd like a reference.
