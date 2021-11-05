### Build
While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty

#### Cache
The system build cache is publicly hosted using [Cachix](https://www.cachix.org) at [maydayv7-dotfiles](https://app.cachix.org/cache/maydayv7-dotfiles), and can be used while building the system to prevent rebuilding from scratch

### Credentials
The authentication credentials are stored in a private repository containing passwords and other security keys, which is imported into the configuration as an `input`, and cloned using the `Github` authentication token. User passwords are made using the command `mkpasswd -m sha-512` and are specified using the `hashedPassword` option

### Scripts
A system management script invoked with the command `nixos` has been included, which can be used to apply user and device configuration changes or perform various other useful functions. The `install` and `setup` scripts have also been included to painlessly install the OS and setup the device, using a single command

### File System
These configuration files can be used to setup the system using either ext4 or BTRFS (with opt-in state). The opt-in state (using TMPFS for `/`) allows for a vastly improved experience, preventing any cruft to form and exerting total control over the device state, by erasing the system at every boot, keeping only what's required/defined

#### Data Storage
User files are stored on an NTFS partition mounted to `/data`