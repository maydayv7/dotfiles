### Boot

To boot into a different build generation, hold down the Spacebar (for `efi`) or the `Shift`/`Esc` key (for `mbr`) upon startup to access the boot menu

#### Secure Boot

To configure Secure Boot, first install the system by using the `efi` loader, then follow [these](https://github.com/nix-community/lanzaboote/blob/v0.3.0/docs/QUICK_START.md) instructions and set `hardware.boot.loader` to `secure`

_If the `advanced` filesystem scheme is used, the keys need to be created after `/etc/secureboot` is persisted_

> **Note:**
> Secure Boot is only supported in EFI Mode

### File System

The system may be set up using either a `simple` or `advanced` filesystem layout. The advanced ZFS encrypted opt-in state filesystem configuration allows for a vastly improved experience, preventing formation of cruft and exerting total control over the device state, by erasing the system at every boot, keeping only what's required

#### Data Storage

All important, persisted user files are stored at `/data`, while persisted system files are stored at `/nix/state`. Personal files and media are stored at `/data/files`
