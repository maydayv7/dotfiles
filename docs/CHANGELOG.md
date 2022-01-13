## Changelog
### v1.0
+ Add MIT License
+ Use NixOS 21.11 (Porcupine)!
+ Add `cachix` Support
+ Add GUI Configuration
  * Use KMSCON as `tty`
  * Use XORG Display Manager
  * Add Custom Fonts Configuration
  * Use `plymouth` for completely silent boot
  * Add Support for GNOME Desktop and Shell Extensions
+ Achieve `system` Independence
+ Improve Modules Configuration
  * Import Modules using `nixosModules`
  * Add Package Overrides into `packages/overlays`
  * Automatically map `modules`, `packages`, `overlays` and `shells`
  * Bifurcate Flake `outputs` (as `configuration.nix`), `scripts` and `secrets`
+ Improve configuration `checks`
  * Check syntax on every commit using CI
+ Add Useful Scripts at `scripts`
  * Add `setup` script
  * Add `nixos` Script with error-checking
  * Add `install` Script to improve Installation Experience
+ Add Hardware Support for 2 devices
  * Add BTRFS (opt-in state) Configuration
  * Add support for using `nixos-hardware` modules
  * Improve Ephemeral Root Support with `impermanence`
+ Add informational README and `docs`
+ Add Support for creating Install Media
  * Automatically publish `.iso` using CI
+ Add Support for pinning repositories with Nix Flakes
  * Add support for NUR
  * Add Support for patching `inputs`
  * Add automatic `flake.lock` update with CI
+ Add Support for Nix Developer Shells at `shells`
  * Add `direnv` support at `shells`
  * Add Support for Instant Nix `repl`
+ Add Program Configuration and archived `dotfiles`
+ Add Custom Libraries for system management at `lib`
+ Use `sops-nix` at `secrets` for managing authentication credentials
+ Added `home-manager` support, tightly integrated into configuration as a `nixosModule`