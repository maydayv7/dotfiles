### Boot

To boot into a different build generation, hold down the Spacebar (for `efi`) or the `Shift`/`Esc` key (for `mbr`) upon startup to access the boot menu

To access recovery settings, open the boot menu and select the `recovery` Specialisation

#### Secure Boot

Set `system.scheme` to `secure` to enable [Secure Boot](https://en.wikipedia.org/wiki/UEFI#Secure_Boot)

The setup should occur automatically on first boot, consult the [docs](https://nix-community.github.io/lanzaboote/) in case of any issue

> [!NOTE]
> Secure Boot is only supported in EFI Mode

### File System

The system may be set up using either a `simple` or `advanced` filesystem scheme. The advanced ZFS encrypted opt-in state filesystem configuration allows for a vastly improved experience, preventing formation of cruft and exerting total control over the device state, by erasing the system at every boot, keeping only what's required

#### Data Storage

All important persisted files are stored at `/data` (declared using either `system.fs.persist`, or `home.persist` for user files), while persisted system files are stored at `/nix/state` (declared using `environment.persist`).  
Personal files and media are stored at `/data/files`, while data synced with [Syncthing](https://syncthing.net/) is at `/data/sync` (defined with `config.flake.files.path`).
