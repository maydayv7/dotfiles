## Known Limitations and/or Workarounds
+ Because of the way that the authentication credentials are cloned, they are world-readable as plain-text files in `/nix/store`
+ The GNOME Extension `Screenshots Location` is currently incompatible with the latest `gnome-shell` version 41, and has been disabled for the time-being
+ Due to [#118612](https://github.com/NixOS/nixpkgs/issues/118612), the GNOME Extension `fly-pie` has been disabled for the time-being (by [#142215](https://github.com/NixOS/nixpkgs/pull/142215))

## Manually Applied Configuration
+ Online Accounts Sign-in
+ Virtual Machine Management
+ Applications
  * App Grid
  * File Associations