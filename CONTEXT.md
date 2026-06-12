# Dendritic Pattern Refactoring — Context Document

## What This Is

A full refactoring of `V:\dotfiles` (repo: `maydayv7/dotfiles`) from a traditional NixOS module structure to the **Dendritic Pattern** for Nix Flakes — an aspect-oriented architecture where every file is a flake-parts module organized by feature.

## Current State

The refactoring is **complete**. All flake outputs evaluate successfully via `nix eval` (verified in WSL with `allow-import-from-derivation true`):

- ✅ 4 NixOS configs: `valkyrie`, `vortex`, `futura`, `install` (+ `valkyrie` `minecraft` specialisation)
- ✅ 3 home-manager configs: `v7@valkyrie`, `v7@vortex`, `navya@futura`
- ✅ 11 devShells, 14 packages, `checks` (treefmt + per-host toplevel)
- ✅ `nix fmt` converges; the `treefmt` CI check derivation builds clean (alejandra + statix + deadnix)

Not yet done: an actual `nix build` of a full system/ISO on real Linux hardware (only `nix eval` has been exercised).

### Directory Structure

```
dotfiles/
├── flake.nix              # Minimal: inputs + mkFlake + import-tree ./modules + explicit imports
├── files/_module.nix      # flake-parts module defining config.flake.files (dotfile paths/data)
├── lib/_module.nix        # flake-parts module defining config.util (map/build helpers)
├── packages/_module.nix   # flake-parts module defining perSystem packages/overlays/legacyPackages
├── secrets/_module.nix    # flake-parts module defining flake.modules.nixos.secrets (sops)
├── modules/               # All dendritic aspect modules (auto-imported via import-tree)
│   ├── core/              # Scaffolding: flake-parts, nixos/home-manager wiring, shells, checks, systems, templates
│   ├── system/            # base, boot, filesystem (ZFS/impermanence), nix, security, user
│   ├── hardware/          # cpu, gpu, laptop, mobile, printer, virtualisation, android, vfio, blockchain
│   ├── shell/             # shell (bash/zsh), shell-utils (bat/eza/yazi), prompt (starship)
│   ├── apps/              # discord, firefox, flatpak, git, git-hosting, git-runner, internet,
│   │                      #   latex, notes, office, spotify, stream, tools, vscode, wine, youtube
│   ├── games/             # games (Steam/Lutris base), osu, minecraft, roblox, mc-server
│   ├── theme/             # theme (stylix), gtk, qt, fonts
│   ├── desktop/           # hyprland/ gnome/ pantheon/ (each folder/default.nix + _-prefixed
│   │                      #   fragments) + _base.nix + _install.nix (install media DE)
│   ├── hosts/             # vortex.nix, futura.nix + valkyrie/ install/ (folder/default.nix + _fragments)
│   └── users/             # navya.nix, _mutable.nix + v7/ (folder/default.nix + assets)
├── files/                 # Raw dotfile data (text configs, images, etc.)
├── lib/                   # Helper functions (map.nix, build.nix, pack.nix, _mime.nix)
├── packages/              # Custom derivations, overlays, patches, _nixpkgs-config.nix
├── scripts/               # Shell scripts (become flake apps)
├── secrets/               # Encrypted secrets (sops) + passwords/ + _module.nix
└── shells/                # Dev shell definitions (11 shells)
```

> Folder convention: `import-tree` auto-imports every `.nix` file under `./modules` whose path
> has no `/_` segment. So an aspect can be a single `feature.nix` **or** a `feature/default.nix`
> folder whose helper fragments are `_`-prefixed (`_features/`, `_main.nix`, etc.) to stay
> out of auto-import while still being explicitly imported by the aspect's `default.nix`.

### Key Architecture Decisions

1. **Every file under `modules/` is a flake-parts module** — auto-imported by `import-tree`.
2. **`_` prefix** excludes files/dirs from import-tree (data files, verbatim sub-configs, non-module helpers).
3. **Module names are FLAT** (`nixos.virtualisation`, not `nixos.hardware.virtualisation`) — directories are purely organizational.
4. **Host composition** explicitly lists aspects: `imports = [ nixos.ssh nixos.boot ... ]`. **Importing a module = enabling it** — there is no `apps.list`/`apps.games`/`hardware.support`/`user.settings` enum-gating framework (those stable-isms were removed). Each game is its own aspect (`nixos.osu`, `nixos.minecraft`, `nixos.roblox`, `nixos.mc-server`).
5. **No specialArgs.** Cross-cutting values (`util`, `files`, `inputs`) are passed by **explicit currying** into `_`-prefixed sub-config files: each takes a leading `{ util ? null, files ? null, inputs ? null }:` static layer, then the normal module layer. The aspect wrapper applies the static layer, e.g. `import ./_features/main.nix { inherit util files inputs; }`. HM modules read host state via `osConfig` (no `sys` currying).
6. **`deferredModule` values can be functions**: `flake.modules.nixos.X = { pkgs, ... }: { ... }`.
7. **`files/_module.nix`, `lib/_module.nix`, `packages/_module.nix`, `secrets/_module.nix`, `site/_module.nix`** are explicitly imported in `flake.nix` (they live beside their data dirs, not under `modules/`).

### Critical Technical Details

- `modules/core/flake-parts.nix` imports `inputs.flake-parts.flakeModules.modules` — required scaffolding.
- `modules/core/nixos.nix` maps `configurations.nixos.<host> = { system; module; }` → `flake.nixosConfigurations`, and sets `nixpkgs.pkgs = config.flake.legacyPackages.<system>` so hosts get the **overlaid/patched** package set (custom, hyprworld, nixFlakes, etc.). Hosts must NOT set `nixpkgs.hostPlatform` (use the `system` field).
- `modules/core/home-manager.nix` builds standalone home configs; it explicitly adds the stylix HM module (+ a default base16 scheme), a no-op `home.persistence` stub (impermanence's HM module is only auto-imported via the NixOS module), and uses the overlaid `legacyPackages`.
- `modules/system/user.nix` wires `home-manager` (useGlobalPkgs/useUserPackages, no specialArgs) and sops user/root passwords via `hashedPasswordFile`. There is **no `user.homeConfig` bypass** — each feature defines a proper `flake.modules.homeManager.<aspect>` that hosts import explicitly. Home-manager modules read system state via the standard `osConfig` argument (guarded with `osConfig ? null` for standalone configs). Extra user groups are set directly in each host's `users.users.<u>.extraGroups`.
- Home-manager modules read host state via `osConfig` (e.g. `nix.index`, `gui.*`, `apps.logseq.style`, `apps.ytmusic.style`), guarded with `osConfig ? null` for standalone configs. `util`/`files` reach HM sub-configs via explicit currying from the aspect orchestrator. Conditional app theming checks real upstream enables (e.g. `config.programs.vscode.enable`), not a custom list.
- `packages/_module.nix` uses direct `import ../lib/map.nix lib` (not `config.util`) to avoid infinite recursion; exposes `flake.legacyPackages`, `flake.overlays`, `flake.patchedPkgs`.
- `packages/_nixpkgs-config.nix` has `_` prefix because `map.modules` would try to `callPackage` it otherwise.
- Desktop aspects are folders: `modules/desktop/hyprland/default.nix` (orchestrator) + `_features/` + `_settings/` + `_idle.nix`; `gnome/default.nix` + `_main.nix` + `_common.nix` + `_settings/`; `pantheon/default.nix` + `_main.nix` + `_settings.nix`. Each Hyprland feature file exports `{ nixos?, home? }` and `default.nix` routes the parts into `nixos.hyprland` / `homeManager.hyprland`; gnome/pantheon follow the same `{nixos, home}` split. `_base.nix` holds the shared graphical-session config (sets `gui.enable = true`) and is imported by every full desktop (not the install media). `_install.nix` is the minimal-GNOME install-media DE (imports `gnome/_common.nix`), imported directly by the install host.
- `nix eval`/`nix build` require `--option allow-import-from-derivation true` (the `nixFlakes`/IFD overlay patches nixpkgs).

### Conventions

- **Formatter is alejandra** (treefmt programs: alejandra, statix, deadnix `no-lambda-arg`, stylua, prettier). VS Code (`nil` LSP) and the `nix.tools` dev set also use `alejandra` (not nixfmt).
- **deadnix caveat:** curried sub-config files must keep `...` in their static layer (`{ util ? null, ..., ... }:`) or deadnix strips the unused args and breaks the call.
- Multi-line `''` strings: alejandra dedents them correctly; avoid leaving blank lines immediately after a `''` opener (a nixfmt artifact that was cleaned up).

## Reference: The Dendritic Pattern

- Every file in `./modules/` is a flake-parts module.
- Each file implements a single feature across all config classes (NixOS + home-manager).
- Values share through `let` bindings, flake-parts options, and explicit currying — never specialArgs.
- Lower-level configs stored as `flake.modules.<class>.<aspect>` with deferredModule type.
- Hosts compose by selecting aspects: `imports = [ config.flake.modules.nixos.ssh ... ]`.
- Auto-import with `import-tree ./modules`.
- Pattern spec: github.com/mightyiam/dendritic
