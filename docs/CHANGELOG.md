## Changelog
### v1.0
+ Use NixOS 21.11 (Porcupine)!
+ Achieve `system` Independence
+ Add archived dotfiles
+ Add `cachix` Support
+ Add README and `docs` directory
+ Add Custom Libraries for device and user management
* Move all program configuration and dotfiles to `files`
+ Use `sops-nix` at `secrets` for managing authentication credentials
+ Add hardware support for 2 devices
  * Add BTRFS (opt-in state) Configuration
  * Improve Ephemeral Root Support with `impermanence`
+ Added `home-manager` support and user dotfiles
  * Merge Device and User Configuration
+ Added repository pinning with Nix Flakes
  * Add support for NUR
  * Add Support for patching `inputs`
+ Add Support for creating Install Media
  * Automatically build `.iso` and publish release using CI
+ Improve configuration `checks`
  * Improve CI with automatic `flake.lock` update and dependency-checking
+ Add Nix Shell Support
  * Add `direnv` support at `shells`
  * Add Support for Nix Developer Shells at `shells`
  * Add Support for Instant Nix `repl`
+ Improve Modules Configuration
  * Import Modules using `nixosModules`
  * Add Mime Types Handling
  * Bifurcate Flake `outputs` (as `configuration.nix`), `scripts` and `secrets`
  * Automatically map `modules`, `packages`, `overlays`, `shells` and `inputs`
  * Add Useful Scripts at `scripts`
    + Add `install` Script to improve Installation Experience
    + Add `setup` script
    + Add `nixos` Script with error-checking
+ Overhaul Package Overrides
  * Handle `scripts` as packages
  * Added essential package overlays
  * Refactor Package Overrides into `packages`