# Dendritic Pattern Refactoring — Context Document

## What This Is

A full refactoring of `V:\dotfiles\nixos` (repo: `maydayv7/dotfiles`) from a traditional NixOS module structure to the **Dendritic Pattern** for Nix Flakes — an aspect-oriented architecture where every file is a flake-parts module organized by feature.

## Current State

The refactoring is **complete**. All flake outputs evaluate successfully via `nix eval` (verified in WSL with `allow-import-from-derivation true`):

- ✅ 4 NixOS configs: `valkyrie`, `vortex`, `futura`, `install` (+ `valkyrie` `minecraft` specialisation)
- ✅ 3 home-manager configs: `v7@valkyrie`, `v7@vortex`, `navya@futura`
- ✅ 11 devShells, 14 packages, `checks` (treefmt + per-host toplevel)
- ✅ `nix fmt` converges; the `treefmt` CI check derivation builds clean (alejandra + statix + deadnix)

Not yet done: an actual `nix build` of a full system/ISO on real Linux hardware (only `nix eval` has been exercised).

### Directory Structure

```
nixos/
├── flake.nix              # Minimal: inputs + mkFlake + import-tree ./modules + explicit imports
├── files/_module.nix      # flake-parts module defining config.flake.files (dotfile paths/data)
├── lib/_module.nix        # flake-parts module defining config.util (map/build helpers)
├── packages/_module.nix   # flake-parts module defining perSystem packages/overlays/legacyPackages
├── modules/               # All dendritic aspect modules (auto-imported via import-tree)
│   ├── core/              # Scaffolding: flake-parts, nixos/home-manager wiring, shells, checks, systems, templates
│   ├── system/            # base, boot, filesystem (ZFS/impermanence), nix, security, secrets, user
│   ├── hardware/          # cpu, gpu, laptop, mobile, printer, virtualisation, android, vfio, blockchain
│   ├── shell/             # shell (bash/zsh), shell-utils (bat/eza/yazi), prompt (starship)
│   ├── apps/              # discord, firefox, flatpak, git, git-hosting, git-runner, internet,
│   │                      #   latex, notes, office, spotify, stream, tools, vscode, wine, youtube
│   ├── games/             # games (Steam/Lutris base), osu, minecraft, roblox, mc-server
│   ├── theme/             # theme (stylix), gtk, qt, fonts
│   ├── desktop/           # hyprland, niri, gnome, pantheon + _base.nix + _shared/ + _hyprland/ _niri/
│   │                      #   _gnome/ _pantheon/ (verbatim settings/apps) + _install.nix (excluded dirs)
│   ├── hosts/             # valkyrie, vortex, futura, install + _valkyrie/ _install/ (excluded)
│   └── users/             # v7, navya + _mutable.nix, _v7/ (excluded)
├── files/                 # Raw dotfile data (text configs, images, etc.)
├── lib/                   # Helper functions (map.nix, build.nix, pack.nix, _mime.nix)
├── packages/              # Custom derivations, overlays, patches, _nixpkgs-config.nix
├── scripts/               # Shell scripts (become flake apps)
├── secrets/               # Encrypted secrets (sops) + passwords/
└── shells/                # Dev shell definitions (11 shells)
```

### Key Architecture Decisions

1. **Every file under `modules/` is a flake-parts module** — auto-imported by `import-tree`.
2. **`_` prefix** excludes files/dirs from import-tree (data files, verbatim sub-configs, non-module helpers).
3. **Module names are FLAT** (`nixos.virtualisation`, not `nixos.hardware.virtualisation`) — directories are purely organizational.
4. **Host composition** explicitly lists aspects: `imports = [ nixos.ssh nixos.boot ... ]`. **Importing a module = enabling it** — there is no `apps.list`/`apps.games`/`hardware.support`/`user.settings` enum-gating framework (those stable-isms were removed). Each game is its own aspect (`nixos.osu`, `nixos.minecraft`, `nixos.roblox`, `nixos.mc-server`).
5. **No specialArgs.** Cross-cutting values (`util`, `files`, `inputs`, `sys`) are passed by **explicit currying** into `_`-prefixed sub-config files: each takes a leading `{ util ? null, files ? null, inputs ? null, sys ? null }:` static layer, then the normal module layer. The aspect wrapper applies the static layer, e.g. `import ./_hyprland/main.nix { inherit util files inputs; }`.
6. **`deferredModule` values can be functions**: `flake.modules.nixos.X = { pkgs, ... }: { ... }`.
7. **`files/_module.nix`, `lib/_module.nix`, `packages/_module.nix`** are explicitly imported in `flake.nix` (not under `modules/`).

### Critical Technical Details

- `modules/core/flake-parts.nix` imports `inputs.flake-parts.flakeModules.modules` — required scaffolding.
- `modules/core/nixos.nix` maps `configurations.nixos.<host> = { system; module; }` → `flake.nixosConfigurations`, and sets `nixpkgs.pkgs = config.flake.legacyPackages.<system>` so hosts get the **overlaid/patched** package set (custom, hyprworld, nixFlakes, etc.). Hosts must NOT set `nixpkgs.hostPlatform` (use the `system` field).
- `modules/core/home-manager.nix` builds standalone home configs; it explicitly adds the stylix HM module (+ a default base16 scheme), a no-op `home.persistence` stub (impermanence's HM module is only auto-imported via the NixOS module), and uses the overlaid `legacyPackages`.
- `modules/system/user.nix` defines `user.homeConfig` (a `mergedAttrs` option whose definitions become `home-manager.sharedModules`) and `user.groups`; it wires sops user/root passwords via `hashedPasswordFile`.
- Home-manager modules receive `util`/`files`/`sys` as module args injected by `nixos.user` via `home-manager.sharedModules` `_module.args` (`sys` = the host config); standalone uses `sys = null`. Reading host state from a HM module uses `osConfig` (e.g. `nix.index`, `apps.logseq.style`, `apps.ytmusic.style`). Conditional app theming checks real upstream enables (e.g. `config.programs.vscode.enable`), not a custom list.
- `packages/_module.nix` uses direct `import ../lib/map.nix lib` (not `config.util`) to avoid infinite recursion; exposes `flake.legacyPackages`, `flake.overlays`, `flake.patchedPkgs`.
- `packages/_nixpkgs-config.nix` has `_` prefix because `map.modules` would try to `callPackage` it otherwise.
- Desktop verbatim sub-configs live under `modules/desktop/_hyprland/`, `_niri/`, `_gnome/`, `_pantheon/` and are imported (with the static-layer applied) by the `nixos.<desktop>` wrappers. `_base.nix` holds the shared graphical-session config; `_shared/` is imported by the wlroots desktops (hyprland/niri).
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
