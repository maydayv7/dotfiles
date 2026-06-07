# Dendritic Pattern Refactoring — Context Document

## What This Is

A full refactoring of `V:\dotfiles\nixos` (repo: `maydayv7/dotfiles`) from a traditional NixOS module structure to the **Dendritic Pattern** for Nix Flakes — an aspect-oriented architecture where every file is a flake-parts module organized by feature.

## Current State (as of 2024-06-08)

The refactoring is ~90% complete. All flake outputs evaluate successfully (`nix eval`), but hasn't been tested with `nix build` yet.

### Directory Structure

```
nixos/
├── flake.nix              # Minimal: inputs + mkFlake + import-tree ./modules + explicit imports
├── files/_module.nix      # flake-parts module defining config.flake.files (dotfile paths/data)
├── lib/_module.nix        # flake-parts module defining config.util (map/build helpers)
├── packages/_module.nix   # flake-parts module defining perSystem packages/overlays
├── modules/               # All dendritic aspect modules (auto-imported via import-tree)
│   ├── core/              # Scaffolding: flake-parts, nixos wiring, home-manager wiring, shells, checks, systems, templates
│   ├── system/            # base, boot, filesystem (ZFS/impermanence), nix, security, secrets, user
│   ├── hardware/          # cpu, gpu, laptop, mobile, printer, virtualisation, android, vfio, blockchain
│   ├── shell/             # shell (bash/zsh), shell-utils (bat/eza/yazi), prompt (starship)
│   ├── apps/              # discord, firefox, flatpak, games, git, git-hosting, git-runner, internet, latex, notes, office, spotify, stream, tools, vscode, wine, youtube
│   ├── theme/             # theme (stylix/GTK/cursors/icons), fonts, qt
│   ├── desktop/           # hyprland, niri, gnome, pantheon + _shared/ (excluded from import-tree)
│   ├── hosts/             # valkyrie, vortex, futura + _valkyrie/ _install/ (excluded)
│   └── users/             # v7, navya + _mutable.nix, _v7/ (excluded)
├── files/                 # Raw dotfile data (text configs, images, etc.)
├── lib/                   # Helper functions (map.nix, build.nix)
├── packages/              # Custom derivations, overlays, patches, _nixpkgs-config.nix
├── scripts/               # Shell scripts (become flake apps)
├── secrets/               # Encrypted secrets (agenix) + passwords/
├── shells/                # Dev shell definitions (11 shells)
├── checks/                # CI check definitions
└── site/                  # Website files
```

### Key Architecture Decisions

1. **Every file under `modules/` is a flake-parts module** — auto-imported by `import-tree`
2. **`_` prefix** excludes files/dirs from import-tree (data files, non-module .nix files)
3. **Module names are FLAT** (`nixos.virtualisation` not `nixos.hardware.virtualisation`) — directories are purely organizational
4. **Host composition** explicitly lists aspects: `imports = [ nixos.ssh nixos.boot ... ]`
5. **No specialArgs** — values shared via `let` bindings or flake-parts options (`config.flake.files`, `config.util`)
6. **`deferredModule` values can be functions**: `flake.modules.nixos.X = { pkgs, ... }: { ... }`
7. **`files/_module.nix`, `lib/_module.nix`, `packages/_module.nix`** are explicitly imported in `flake.nix` (not under `modules/`)

### Critical Technical Details

- `modules/core/flake-parts.nix` imports `inputs.flake-parts.flakeModules.modules` — required scaffolding
- `modules/core/nixos.nix` maps `configurations.nixos` → `flake.nixosConfigurations` (no pipe operator — not enabled)
- `packages/_module.nix` uses direct `import ../lib/map.nix lib` (not `config.util`) to avoid infinite recursion
- `packages/_nixpkgs-config.nix` has `_` prefix because `map.modules` would try to `callPackage` it otherwise
- The `site/` directory no longer exists but `templates.nix` references `../../site` — may need checking

### What's Working

- ✅ All 3 NixOS configs evaluate: `valkyrie`, `vortex`, `futura`
- ✅ All 3 home-manager configs: `v7@valkyrie`, `v7@vortex`, `navya@futura`
- ✅ All 11 devShells: android, cc, default, format, java, js, lua, python, rust, sql, video
- ✅ All 14 packages evaluate
- ✅ Comments from old config preserved (section headers + inline)

## Remaining Work

### Must Do

1. **Test with `nix build`** — only `nix eval` tested so far. Actual builds may reveal runtime issues.
2. **Desktop modules are simplified stubs** — the old config had MASSIVE detailed hyprland/niri/gnome configs in `settings/` and `apps/` subdirectories. The new desktop modules only have basic structure. The `_shared/` directory was copied but the desktop-specific settings were not fully migrated.
3. **Game submodules** — `osu.nix`, `roblox.nix`, `mc-server.nix` exist in old config but aren't separate aspect modules yet. Currently only `minecraft.nix` is imported via `_valkyrie/minecraft.nix`.
4. **vortex and futura hosts** — may be missing some of the new aspects (vscode, spotify, games, etc.) that valkyrie now has
5. **Git user credentials** — the old `git/user.nix` had signing key config imported per-user. The new `git.nix` doesn't have user-specific git identity (name/email/signing). This should come from the user module (`users/v7.nix`).

### Nice to Have

- Run linter/formatter on all new files
- Delete any remaining dead code
- Verify all persist directories are correct
- Test on actual hardware

## Reference: The Dendritic Pattern

- Every file in `./modules/` is a flake-parts module
- Each file implements a single feature across all config classes (NixOS + home-manager)
- Values share through `let` bindings and flake-parts options, never specialArgs
- Lower-level configs stored as `flake.modules.<class>.<aspect>` with deferredModule type
- Hosts compose by selecting aspects: `imports = [ config.flake.modules.nixos.ssh ... ]`
- Auto-import with `import-tree ./modules`
- Pattern spec: github.com/mightyiam/dendritic
