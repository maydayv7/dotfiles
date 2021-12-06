### Build
While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty

#### Cache
The system build cache is publicly hosted using [Cachix](https://www.cachix.org) at [maydayv7-dotfiles](https://app.cachix.org/cache/maydayv7-dotfiles), and can be used while building the system to prevent rebuilding from scratch

#### Continuous Integration
This repository makes use of `Github Actions` (placed in [`.github/workflows`](../.github/workflows)) in order to automatically check the syntax on every push, update the `inputs` every 10 days, build the configuration and upload the build cache to Cachix, and build the `.iso` and upload it to a draft release upon creation of a tag

### Credentials
The authentication credentials are managed using [`sops-nix`](https://github.com/Mic92/sops-nix) at [`secrets`](../secrets). The encrypted keys (using GPG authentication) are stored at [`secrets/encrypted`](../secrets/encrypted), and keys unencrypted by [`sops`](https://github.com/mozilla/sops) (but managed using `git-crypt`) are located at [`secrets/unencrypted`](../secrets/unencrypted). User passwords are made using the command `mkpasswd -m sha-512` and specified using the `passwordFile` option

### Scripts
A system management script, invoked with the command `nixos`, has been included, which can be used to apply user and device configuration changes or perform various other useful functions. (If you have a working NixOS install, you can check it out using `nix run github:maydayv7/dotfiles`). The `install` and `setup` scripts have also been provided at [`scripts`](../scripts) to painlessly install the OS and setup the device, using a single command

### File System
The system may be set up using either a simple or advanced filesystem layout. The advanced BTRFS opt-in state filesystem configuration (using TMPFS for `/`) allows for a vastly improved experience, preventing formation of cruft and exerting total control over the device state, by erasing the system at every boot, keeping only what's required

#### Data Storage
User files are stored on an NTFS partition mounted to `/data`