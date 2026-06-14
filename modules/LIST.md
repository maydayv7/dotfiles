# Module List

An overview of every configuration module in this repository.

**Type** indicates whether a module extends `flake.modules.nixos`, `flake.modules.homeManager`, or both.

**★** marks modules imported by default.

---

## `modules/apps/`

| Module        | Type         | Description                |
| ------------- | ------------ | -------------------------- |
| `discord`     | Home Manager | Discord chat client        |
| `firefox`     | Home Manager | Firefox browser            |
| `internet`    | Home Manager | Internet apps              |
| `notes`       | Home Manager | Logseq note-taking         |
| `spotify`     | Home Manager | Spotify music client       |
| `stream`      | Home Manager | Streaming tools            |
| `youtube`     | Home Manager | YouTube tooling            |
| `vscode`      | Home Manager | Visual Studio Code editor  |
| `flatpak`     | Both         | Flatpak app sandboxing     |
| `latex`       | Both         | LaTeX typesetting          |
| `office`      | Both         | Office suite environment   |
| `tools`       | Both         | General CLI/GUI tools      |
| `wine`        | Both         | Wine Windows compatibility |
| `git`         | Both         | `git` version control      |
| `git-hosting` | NixOS        | Gitea code hosting         |
| `git-runner`  | NixOS        | GitHub/GitLab CI runner    |

## `modules/desktop/`

| Module     | Type | Description               |
| ---------- | ---- | ------------------------- |
| `gnome`    | Both | GNOME desktop environment |
| `hyprland` | Both | Hyprland window manager   |

## `modules/games/`

| Module      | Type         | Description                      |
| ----------- | ------------ | -------------------------------- |
| `games`     | Both         | Gaming environment (Steam, etc.) |
| `minecraft` | Home Manager | Minecraft client                 |
| `osu`       | Home Manager | osu! rhythm game                 |
| `mc-server` | NixOS        | Minecraft server                 |
| `roblox`    | NixOS        | Roblox client                    |

## `modules/gui/`

| Module    | Type  | Description                  |
| --------- | ----- | ---------------------------- |
| `fonts` ★ | NixOS | System fonts                 |
| `theme` ★ | Both  | System-wide theming (Stylix) |
| `gtk`     | Both  | GTK theming                  |
| `qt`      | Both  | Qt theming                   |

## `modules/hardware/`

| Module       | Type  | Description                  |
| ------------ | ----- | ---------------------------- |
| `laptop`     | Both  | Laptop power/hardware tweaks |
| `cpu`        | NixOS | CPU configuration            |
| `gpu`        | NixOS | GPU configuration            |
| `mobile`     | NixOS | Device/mobile firmware       |
| `printer`    | NixOS | Printer firmware & drivers   |
| `blockchain` | NixOS | Blockchain/crypto support    |

## `modules/shell/`

| Module        | Type  | Description               |
| ------------- | ----- | ------------------------- |
| `shell` ★     | Both  | Shell (zsh) configuration |
| `shell-utils` | Both  | Shell utilities           |
| `prompt`      | NixOS | Shell prompt              |

## `modules/system/`

| Module       | Type  | Description                         |
| ------------ | ----- | ----------------------------------- |
| `base` ★     | Both  | Base system configuration           |
| `nix` ★      | Both  | Nix daemon & settings               |
| `user` ★     | Both  | User accounts & Home Manager wiring |
| `filesystem` | Both  | File system layout                  |
| `base-ext`   | NixOS | Extended base configuration         |
| `boot`       | NixOS | Boot loader configuration           |
| `security`   | NixOS | Security & hardening                |

## `modules/users/`

| Module  | Type         | Description          |
| ------- | ------------ | -------------------- |
| `v7`    | Home Manager | `v7` user profile    |
| `navya` | Home Manager | `navya` user profile |

## `modules/virt/`

| Module    | Type  | Description                 |
| --------- | ----- | --------------------------- |
| `libvirt` | Both  | Libvirt/QEMU virtualisation |
| `android` | NixOS | Android virtualisation      |
| `docker`  | NixOS | Docker containers           |
| `vfio`    | NixOS | VFIO GPU passthrough        |

## `secrets/`

| Module      | Type  | Description                   |
| ----------- | ----- | ----------------------------- |
| `secrets` ★ | NixOS | Secrets management (sops-nix) |
