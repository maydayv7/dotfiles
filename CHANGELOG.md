## 2026

### June

- Add `auth`, `syncthing`, `mouse`
- Use Thunderbird for mail
- Upgrade to NixOS 26.05
- Drop Niri & Pantheon
- Support standalone `home-manager` configurations
- Refactor NixOS Configuration to use [dendritic](https://github.com/mightyiam/dendritic) pattern
- Switch back formatter to `alejandra`
- Switch back to NixOS (Yay!)
- Create website favicon
- Update website to use Zola v0.22
  - Fix search and anchor links
  - Update syntax highlighting and lazy-load images
  - Support GitHub alerts

### April

- More Windows Configuration
  - Windhawk
  - Powertoys
  - AutoHotKey Scripts
  - WSL

### March

- Move to Windows
  - Add YASB Configuration
  - Update Rainmeter Skin
- Refactor directory Structure

### February

- Use `sunsetr` for Display Temperature Control

### January

- Update `impermanence` setup (`user.persist` -> `home.persist`)
- Update Hyprland to v0.53
- Update mimetypes
- Refactor `apps`
  - Add `internet`, `tools`, `stream`
  - Remove `media`
  - Install KeePassXC
- Fix NVIDIA PRIME
- Fix `flatpak` Configuration
- Refine `apps.games`
  - Add support for Roblox
- `site` Changes
  - Start blogging!
  - Fix comments
  - `git` frontend using `stagit`

## 2025

### December

- Deploy `site` to Cloudflare
  - Drop GitHub Pages and Netlify
- Use `stevenblack` blocklist
- Refactor `hardware.gpu` and add `hardware.cpu.model`
- Use `swaync` instead of `dunst`
- Niri Updates
  - Update to v25.11
  - Use UWSM
  - Use `wlr` instead of `gnome` XDG Portal
- Use `pwvucontrol` instead of `pavucontrol`
- Patch `nom` rendering
- Add an AppImage manager
- Add a LaTeX Editor
- GNOME Updates
  - Change terminal hotkeys
  - Use [`copyous`](https://github.com/boerdereinar/copyous) instead of `pano`
- Fix VFIO after update
- `git` Fixes
  - Hooks
  - GitHub authentication
- Update to NixOS 25.11 (Xantusia)

### November

- Add Android development shell
- Support multiple concurrent Minecraft Servers
- Update Hyprland to v0.52
- Add modded skyblock Minecraft Server

### October

- Hyprland Updates
  - Use Waybar's `workspace-taskbar`
  - Update to v0.51
  - Use `hyprexpo` instead of `hyprspace`
- Use Brave instead of Chrome
- Add `fabric-ca` package for Hyperledger Fabric
- Add Stremio

### September

- Support Hyperledger Fabric Blockchain Development

### August

- Add Configuration for Niri WM
  - Use `rofi-wayland` as launcher
  - Share configuration with Hyprland

### July

- Add Hyprland Shaders
- Update Hyprland to v0.50
- Rename `hardware.filesystem` -> `hardware.fs` and improve
- Improve `nixos apply --delta`
- Add Minecraft Server Configuration
- Update GNOME Extensions

### June

- Hyprland QOL Fixes
  - `dunst` use pause levels
  - `waybar` separate configuration for different monitors
- Use `nixpkgs-wayland`
- Add YT Music configuration
- Add `tmux` configuration
- Drop KMSCon
- Update `adwaita` colors

### May

- Use `nixcord`
- Use `ddterm` with GNOME
- Update to NixOS 25.05 (Warbler)
  - Drop XFCE Desktop
  - Drop `nixos-generators` -> Refactor install media configuration
  - Build system from patched `nixpkgs`
- Abolish versioning

---

### v25.5

- Remove package `channels`
- Update Hyprland to v0.49
  - Use `hyprshell` to switch between windows
  - Use `pcmanfm-qt` to render desktop icons
  - Use animations from [end4](https://github.com/end-4/dots-hyprland)
  - New `pyprland` scratchpads
- Update Shell Configuration
  - Use `fastfetch`
  - Use [`starship`](https://starship.rs/) shell prompt theme
- Improve QT Theming
- Add `apps.games`
- Drop ULauncher Configuration (`gui.launcher`)

### v25

- Upgrade to NixOS v24.11 (Vicuna)!
- Add Logseq Configuration
- Use Vesktop instead of Discord
- Hyprland Improvements
  - Transition to UWSM
  - Use `nixpkgs` version
  - Use [`nemo`](https://community.linuxmint.com/software/view/nemo) File Manager
  - Add KDE Connect Support
- GNOME Changes
  - Drop PaperWM for Tiling Shell
  - Drop Blackbox for Ghostty
- Add Steam Support
- Update Wine Packages
- Improve Website
- Fix Python Shell

### v24.5

- GNOME Improvements
  - Use [PaperWM](https://github.com/paperwm/PaperWM) and [Pano](https://github.com/oae/gnome-shell-pano)
  - Remove unneeded extensions
- Add Looking Glass to VFIO Configuration
- Remove needless `wfvm` Configuration
- Refine Specialisations

### v24

- Hyprland Improvements
  - Update to version 0.40
  - Desktop Icons
  - Keybindings List
  - Useful Submaps
  - Panel Improvements
  - Border Gradients
  - Revamp `hyprutils` Script
  - Compositor Shaders
  - Use [`clipse`](https://github.com/savedra1/clipse) for Clipboard
  - Use amazing plugins
    - [Hycov](https://github.com/DreamMaoMao/hycov)
    - [Hyprspace](https://github.com/KZDKM/Hyprspace)
    - [Hyprexpo](https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo)
- Add device `valkyrie` and fix NVIDIA issues
- Improve GNOME Configuration
  - Use [`tiling-shell`](https://github.com/domferr/tilingshell) instead of `forge`
  - Support NVIDIA GPUs and PRIME
- Add `devcontainer` for GitHub Codespaces
- Add configuration for Spotify using [`spicetify-nix`](https://github.com/Gerg-L/spicetify-nix)
- Make VS Code Configuration mutable using [this](https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa) module
- Reimplement support for specifying Package Channel for configuration build
- Refactor Install Media build and upload image as GitHub artifact to circumvent size limit

### v17

- Re-expose `lib.build.device`
- Add Hyprland Configuration
- Refactor GNOME `dconf`
- Overhaul XFCE Configuration
  - Use ULauncher
  - Use the Picom Compositor
- Add Pantheon Desktop Configuration
- Add VS Code Extensions Repository
- Fix Android Virtualisation
- Support running AppImages
- Add multiple `gui` Modules
- Refactor and add `hardware.cpu`
- Add `sql` Shell
- Actually persist `~/.local/share/Trash`

### v15

- Use the [`flake-parts`](https://flake.parts/) Flakes framework
- Improve Syntax Formatting with `treefmt-nix` and drop `pre-commit-hooks`
- Support declarative [Flatpak](https://flatpak.org/) application install
- Update Nix to version 2.19
- Enable Security & Hardening settings by default
- Add Boot Recovery Settings
- Support Secure Boot using [`lanzaboote`](https://github.com/nix-community/lanzaboote)
- Allow patching Default Package Channel
- Show package delta using [`nvd`](https://gitlab.com/khumba/nvd)
- Upgrade to GNOME 45
  - Update Extensions
- Fix Emoji Support
- Drop `.templates`
- Multiple Refactors
  - Separate `games` and `laptop` module
  - Separate `install` Script
  - Stop exposing `nixosModules`
  - Fix `user.homeConfig`

### v13

- Follow NixOS Unstable
- Improve `nix-index`
- Move out proprietary files
- Refactor Secrets
- Drop `deploy-rs` Support
- Remove `inputs` patching Support
- Fix first boot installation
- Add conditional to `lib.map.files`
- Add `gui.{wallpaper,wayland}`

### 23.05 (v12)

- Upgrade to NixOS v23.05 (Stoat)!
- Drop `cod`, `nix-linter`, `gedit`, `touchegg`, `vscode-server` and `mutter-rounded`
- Support Android Virtualisation using Waydroid
- Drop `compat` Libraries
- Refactor GNOME Experience
  - Use `blackbox` as default terminal
  - Use [`forge`](https://github.com/forge-ext/forge) for tiling
  - Add keyboard shortcuts window using [`shortcuts`](https://gitlab.com/paddatrapper/shortcuts-gnome-extension)
- Improve XFCE Configuration and Handling
- Improve Automatic Package Update Script
- Enable ZFS encryption
- Support Network Printing

### 22.11 (v11)

- Upgrade to NixOS v22.05 (Quokka)!
- Add `lib.map.array`
- Improve `nixos` Script
- Add `gui.fonts.usershare`
- General Maintenance Updates
- Use [`treefmt`](https://github.com/numtide/treefmt) for Formatting Code

### 22.04 (v10)

- Deprecate `git-crypt` Usage
- Improve Installation Experience
- Begin Work on Blog
- Stabilize with multiple Bug-Fixes

<details>
<summary><i>Archive</i></summary>

### v7.0

- Create Website using [Zola](https://www.getzola.org/)
- Refine Compatibility Libraries
- Refine Scripts
  - Use `nix-shell` Shebangs
  - Add `lib.build.script`
- Support Visual Studio Code Editor
- Use [`alejandra`](https://github.com/kamadorueda/alejandra) for formatting code

### v5.0

- Improve `channels` Usage
- Support `source` Filters
- Refine `git` Configuration
- Use `wine` Application Wrapper
- Use System Independent `library`
- Add Support for Ephemeral `/home`
- Add Configuration for [XFCE](https://xfce.org/) Desktop
- Bifurcate `users` and Refine User Configuration
- Support Automatic `packages` Updates using `update.sh`
- Add Support for Automatic Deployments using [`deploy-rs`](https://github.com/serokell/deploy-rs)
- Add Developer `shells` for Multiple Programming Languages integrated with [`lorri`](https://github.com/nix-community/lorri)

### v4.5

- Use Calendar Versioning
- Use `nixConfig`
- Support Auto-Upgrade
- Support Multiple Users per Device
- Improve Security and Harden System
- Use PipeWire (with low-latency) for audio
- Use [`nixos-generators`](https://github.com/nix-community/nixos-generators) for Image Generation

### v4.0

- Use `nixConfig`
- Bifurcate `devices`
  - Refactor `lib.build.system` into `build.iso` and `build.device`
- Improve `lib` Handling
- Improve Module Imports
- Improve and Bifurcate `docs`
- Handle `scripts` as packages
- Improve configuration `checks`
- Achieve `system` Independence
- Add `.editorconfig` and `nanorc`
- Refactor `sops` Encrypted Secrets
- Stabilise and document `templates`
- Fix `devshells`, `repl` and `scripts`
- Fix Module Imports and `inputs` Patching
- Improve Mime Types Handling with `lib.xdg`
- Use `advanced` Ephemeral Root File System Layout with [ZFS](https://zfsonlinux.org/)
- Use [`flake-compat`](https://github.com/edolstra/flake-compat), [`nix-gaming`](https://github.com/fufexan/nix-gaming) and [`nix-wayland`](https://github.com/nix-community/nix-wayland)
- Improve Code Consistency, reduce Complexity and fix Syntactic and Semantic Errors
  - Use [`pre-commit-hooks`](https://github.com/cachix/pre-commit-hooks.nix) to improve configuration `checks`
  - Use [`nixfmt`](https://github.com/serokell/nixfmt) for formatting code
  - Use [`nix-linter`](https://github.com/Synthetica9/nix-linter) to check stylistic errors

### v3.0

- Upgrade to NixOS v21.11 (Porcupine)!
- Improve Package Declaration
- Add Support for Instant Nix REPL
- Add Support for patching `inputs`
- Improve usage of Developer Shells
- Import Modules using `nixosModules`
- Use [`home-manager`](https://github.com/nix-community/home-manager) as a Module
- Merge Device and User Configuration
- Move all program configuration and dotfiles to `files`
- Use [`sops-nix`](https://github.com/Mic92/sops-nix) at `secrets` for managing authentication credentials
- Automatically map `modules`, `packages`, `overlays`, `shells` and `inputs`

### v2.3

- Add `docs` directory
- Fix `.iso` Boot and Install Errors
- Improve Scripts with error-checking
- Add `direnv` support at `shells`
- Add Support for Nix Developer Shells at `shells`
- Use `secrets` as an `input` rather than as a `submodule`
- Improve CI with automatic `flake.lock` update and dependency-checking
- Bifurcate Flake `outputs` (as `configuration.nix`), `scripts` and `overlays`

### v2.1

- Simplify Installation
  - Add `install` Script
  - Add Support for creating Install Media
  - Add overhauled `setup` Script
  - Automatically build `.iso` and publish release using CI
- Fix Home Activation

### v2.0

- Add BTRFS (opt-in state) Configuration
- Improve Ephemeral Root Support with [impermanence](https://github.com/nix-community/impermanence)
- Improve Installation Experience
- Improve Home Activation
- Bifurcate Modules and Roles
- Reduce CI Time
- Add the Office role

### v1.0

- Add Cachix Support
- Add Nix Shell Support
- Increase Readability
- Improve Package Management
- Under the hood CI changes

### v0.7

- Improve Secrets Management using Private Submodule at `secrets`
- Overhaul Package Overrides
  - Use `final: prev:` instead of `self: super:`
  - Add support for NUR
  - Split System Scripts and import as overlay
  - Refactor Package Overrides into `packages`
- Add archived `dotfiles` and revitalize existing ones
- Improve Modulated Imports
- Improve Fonts Management
- Update README and `scripts`

### v0.5

- Added Support for Nix Flakes
- Added Custom Libraries for Device and User Management
- Created System Management Script
- Updated README and `install` Script
- Add full support for Multi-Device Configuration
- Use Better Repository Management

### v0.1

- Added basic NixOS system configuration using GNOME and GTK+
- Added hardware support for 2 devices
- Added `setup` script
- Added `home-manager` support and user dotfiles
- Added Modulated Configuration
- Added Support for Nix User Repository
- Added Repository Pinning
- Added Essential Package Overlays
- Added Basic Password Management
- Added README
