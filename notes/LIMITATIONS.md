## Known Issues
#### Nix
+ Due to [#5284](https://github.com/NixOS/nix/pull/5284), it has become imperative to clone the `secrets` submodule using a `github` authentication token as a Flake `input`, which complicates both installation and management

#### Packages
+ Due to [#118612](https://github.com/NixOS/nixpkgs/issues/118612), the GNOME Extension `fly-pie` has been disabled for the time-being (by [#142215](https://github.com/NixOS/nixpkgs/pull/142215))

## Manually Applied Configuration
+ Online Accounts Sign-in
+ Virtual Machine Management
+ Applications
  * App Grid
  * File Associations