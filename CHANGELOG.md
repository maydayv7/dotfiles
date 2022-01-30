## Changelog
### v4.5 - 20220130
+ Use Calendar Versioning
+ Use `nixConfig`
+ Support Auto-Upgrade
+ Support Multiple Users per Device
+ Improve Security and Harden System
+ Use PipeWire (with low-latency) for audio
+ Use [`nixos-generators`](https://github.com/nix-community/nixos-generators) for Image Generation

### v4.0
+ Use `nixConfig`
+ Bifurcate `devices`
  * Refactor `lib.build.system` into `build.iso` and `build.device`
+ Improve `lib` Handling
+ Improve Module Imports
+ Improve and Bifurcate `docs`
+ Handle `scripts` as packages
+ Improve configuration `checks`
+ Achieve `system` Independence
+ Add `.editorconfig` and `nanorc`
+ Refactor `sops` Encrypted Secrets
+ Stabilise and document `templates`
+ Fix `devshells`, `repl` and `scripts`
+ Fix Module Imports and `inputs` Patching
+ Improve Mime Types Handling with `lib.xdg`
+ Use `advanced` Ephemeral Root File System Layout with [ZFS](https://zfsonlinux.org/)
+ Use [`flake-compat`](https://github.com/edolstra/flake-compat), [`nix-gaming`](https://github.com/fufexan/nix-gaming) and [`nix-wayland`](https://github.com/nix-community/nix-wayland)
+ Improve Code Consistency, reduce Complexity and fix Syntactic and Semantic Errors
  * Use [`pre-commit-hooks`](https://github.com/cachix/pre-commit-hooks.nix) to improve configuration `checks`
  * Use [`nixfmt`](https://github.com/serokell/nixfmt) for formatting code
  * Use [`nix-linter`](https://github.com/Synthetica9/nix-linter) to check stylistic errors

### v3.0
+ Upgrade to NixOS v21.11 (Porcupine)!
+ Improve Package Declaration
+ Add Support for Instant Nix REPL
+ Add Support for patching `inputs`
+ Improve usage of Developer Shells
+ Import Modules using `nixosModules`
+ Use [`home-manager`](https://github.com/nix-community/home-manager) as a Module
+ Merge Device and User Configuration
* Move all program configuration and dotfiles to `files`
+ Use [`sops-nix`](https://github.com/Mic92/sops-nix) at `secrets` for managing authentication credentials
+ Automatically map `modules`, `packages`, `overlays`, `shells` and `inputs`

### v2.3
+ Add `docs` directory
+ Fix `.iso` Boot and Install Errors
+ Improve Scripts with error-checking
+ Add `direnv` support at `shells`
+ Add Support for Nix Developer Shells at `shells`
+ Use `secrets` as an `input` rather than as a `submodule`
+ Improve CI with automatic `flake.lock` update and dependency-checking
+ Bifurcate Flake `outputs` (as `configuration.nix`), `scripts` and `overlays`

### v2.1
+ Simplify Installation
  * Add `install` Script
  * Add Support for creating Install Media
  * Add overhauled `setup` Script
  * Automatically build `.iso` and publish release using CI
+ Fix Home Activation

### v2.0
+ Add BTRFS (opt-in state) Configuration
+ Improve Ephemeral Root Support with [impermanence](https://github.com/nix-community/impermanence)
+ Improve Installation Experience
+ Improve Home Activation
+ Bifurcate Modules and Roles
+ Reduce CI Time
+ Add the Office role

### v1.0
+ Add Cachix Support
+ Add Nix Shell Support
+ Increase Readability
+ Improve Package Management
+ Under the hood CI changes

### v0.7
+ Improve Secrets Management using Private Submodule at `secrets`
+ Overhaul Package Overrides
  * Use `final: prev:` instead of `self: super:`
  * Add support for NUR
  * Split System Scripts and import as overlay
  * Refactor Package Overrides into `packages`
+ Add archived dotfiles and revitalize existing ones
+ Improve Modulated Imports
+ Improve Fonts Management
+ Update README and scripts

### v0.5pre
+ Added support for Nix Flakes
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