## Changelog
### v2.2
+ Add `docs` directory
+ Fix `.iso` Boot and Install Errors
+ Add Support for Nix Developer Shells at `shells`
+ Improve CI with automatic `flake.lock` update and dependency-checking

### v2.1
+ Simplify Installation (#13)
  * Add `install` Script
  * Add Support for creating Install Media
  * Add overhauled `setup` Script
  * Automatically build `.iso` and publish release using CI
+ Fix Home Activation

### v2.0
+ Add BTRFS (opt-in state) Configuration (#12)
+ Improve Ephemeral Root Support with [impermanence](https://github.com/nix-community/impermanence)
+ Improve Installation Experience
+ Improve Home Activation
+ Bifurcate Modules and Roles
+ Reduce CI Time
+ Add the Office role

### v1.0
+ Add Cachix Support (#10)
+ Add Nix Shell Support (#11)
+ Increase Readability
+ Improve Package Management
+ Under the hood CI changes

### v0.7
+ Improve Secrets Management using Private Submodule at `secrets` (#7)
+ Overhaul Package Overrides
  * Use `final: prev:` instead of `self: super:` (#9)
  * Add support for NUR
  * Split System Scripts and import as overlay
  * Refactor Package Overrides into `packages` (#8)
+ Add archived dotfiles and revitalize existing ones
+ Improve Modulated Imports
+ Improve Fonts Management
+ Update README and scripts

### v0.5pre
+ Added support for Nix Flakes (#5)
+ Added Custom Libraries for device and user management
+ Created system management script
+ Update README and install script
+ Add full support for multi-device configuration
+ Use better repository management

### v0.1pre
+ Added basic NixOS system configuration using GNOME and GTK+
+ Added hardware support for 2 devices
+ Added `setup` script
+ Added `home-manager` support and user dotfiles
+ Added modulated configuration
+ Added Nix User Repository
+ Added repository pinning
+ Added essential package overlays
+ Added basic password management
+ Added README