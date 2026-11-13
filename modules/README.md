# Configuration Modules

The `modules` directory contains the custom configuration modules that form the very core of my configuration for multiple PCs and various use-cases, that follows the [dendritic](https://github.com/mightyiam/dendritic) pattern:

- Directories are purely organizational
- Files prefixed with `_` are not auto-imported
- [`core`](./core): `flake-parts` plumbing that wires everything together
- [`lib`](./lib/README.md): custom utility functions exposed through `util`, with helper files excluded from auto-import
- [`hosts`](./hosts): per-device configuration, declared as `configurations.nixos.<host>` and `configurations.homeManager.<user@host>`, composing the modules below
- [`users`](./users/): user accounts and user-specific Home Manager configurations

## Module List

An overview of every configuration module in this repository.

- **Type** indicates whether a module extends `flake.modules.nixos`, `flake.modules.homeManager`, or both
- **★** marks modules imported by default
- **◇** marks WSL-compatible modules (' for HM-only)

#### WSL

The [`wsl` host](./hosts/wsl) provides [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) configuration.  
`<name>-cli` holds reusable command-line settings when `<name>` also includes desktop/native-host configuration.

### [`apps`](./apps)

| Module              | Type         | Description                        |
| ------------------- | ------------ | ---------------------------------- |
| `auth`              | Home Manager | Authentication credential managers |
| `audio`             | Home Manager | Audio controls and routing         |
| `brave`             | Home Manager | Brave browser                      |
| `calibre`           | Home Manager | Calibre E-Book manager             |
| `discord`           | Home Manager | Discord chat client                |
| `easyeffects`       | Home Manager | Audio effects and presets          |
| `firefox`           | Home Manager | Firefox browser                    |
| `freefilesync`      | Home Manager | File synchronization               |
| `gearlever`         | Home Manager | AppImage manager                   |
| `gimp`              | Home Manager | GIMP image editor                  |
| `handbrake`         | Home Manager | Video converter                    |
| `inkscape`          | Home Manager | Vector editor                      |
| `libreoffice`       | Home Manager | LibreOffice suite                  |
| `media`             | Home Manager | Media utilities                    |
| `network`           | Both         | Network tools & Wireshark          |
| `notes`             | Home Manager | Obsidian Notes                     |
| `onlyoffice`        | Home Manager | OnlyOffice suite                   |
| `pdf`               | Home Manager | PDF editing, annotation, scanning  |
| `pitivi`            | Home Manager | Pitivi video editor                |
| `spotify`           | Home Manager | Spotify music client               |
| `stream`            | Home Manager | Streaming tools                    |
| `syncthing` ◇       | Both         | Syncthing file sync                |
| `teams`             | Home Manager | Microsoft Teams client             |
| `thunderbird`       | Home Manager | Mail Client                        |
| `youtube`           | Home Manager | YouTube Music & TUI                |
| `vscode`            | Home Manager | Visual Studio Code editor          |
| `whatsapp`          | Home Manager | ZapZap WhatsApp client             |
| `zed`               | Home Manager | Zed Editor                         |
| `zoom`              | Home Manager | Zoom meeting client                |
| `flatpak`           | Both         | Flatpak app sandboxing             |
| `latex`             | Both         | LaTeX typesetting                  |
| `obs-studio`        | Both         | OBS Studio                         |
| `office`            | Both         | Shared Office environment          |
| `wine`              | Both         | Wine Windows compatibility         |
| `git` ◇             | Both         | `git` version control              |
| `git-hosting` ◇     | NixOS        | Gitea code hosting                 |
| `git-runner` ◇      | NixOS        | GitHub/GitLab CI runner            |
| `antigravity-cli` ◇ | Home Manager | Google Antigravity CLI             |
| `antigravity`       | Home Manager | Antigravity CLI + IDE              |
| `codex-cli` ◇       | Home Manager | OpenAI Codex CLI                   |
| `codex`             | Home Manager | Codex CLI + Desktop                |
| `claude-cli` ◇      | Home Manager | Anthropic Claude CLI               |
| `claude`            | Both         | Anthropic Claude CLI + Desktop     |

### [`desktop`](./desktop)

| Module     | Type | Description               |
| ---------- | ---- | ------------------------- |
| `gnome`    | Both | GNOME desktop environment |
| `hyprland` | Both | Hyprland window manager   |
| `niri`     | Both | Niri window manager       |

### [`games`](./games)

| Module      | Type         | Description                        |
| ----------- | ------------ | ---------------------------------- |
| `games`     | Both         | Gaming environment (Lutris, Steam) |
| `minecraft` | Home Manager | Minecraft client                   |
| `osu`       | Home Manager | osu! rhythm game                   |
| `mc-server` | NixOS        | Minecraft server                   |
| `roblox`    | NixOS        | Roblox client                      |

### [`gui`](./gui)

| Module        | Type | Description         |
| ------------- | ---- | ------------------- |
| `theme` ★     | Both | System-wide theming |
| `theme-cli` ◇ | Both | CLI/TUI theming     |
| `fonts` ★     | Both | System fonts        |
| `gtk`         | Both | GTK theming         |
| `qt`          | Both | Qt theming          |

### [`hardware`](./hardware)

| Module         | Type  | Description         |
| -------------- | ----- | ------------------- |
| `cpu` ★        | NixOS | CPU configuration   |
| `gpu` ★        | NixOS | GPU configuration   |
| `laptop`       | Both  | Laptop tweaks       |
| `mouse`        | Both  | Mouse configuration |
| `mobile`       | NixOS | Mobile firmware     |
| `printer`      | NixOS | Printer firmware    |
| `blockchain` ◇ | NixOS | Blockchain support  |

### [`shell`](./shell)

| Module          | Type  | Description         |
| --------------- | ----- | ------------------- |
| `shell` ★ ◇'    | Both  | Shell configuration |
| `shell-cli` ◇   | NixOS | Shells & TUIs       |
| `shell-utils` ◇ | Both  | Shell utilities     |
| `prompt` ◇      | NixOS | Shell prompt        |

### [`system`](./system)

| Module            | Type  | Description                          |
| ----------------- | ----- | ------------------------------------ |
| `base` ★ ◇'       | Both  | Base system configuration            |
| `base-cli` ◇      | NixOS | Shared base utilities & declarations |
| `doc` ◇           | NixOS | Man pages and dev docs               |
| `appimage`        | NixOS | AppImage execution support           |
| `ld` ◇            | NixOS | Dynamic binary compatibility         |
| `kmscon`          | NixOS | KMSCON virtual console               |
| `crypt` ◇         | Both  | GPG agent & SSH client/server        |
| `boot` ★          | NixOS | Boot loader configuration            |
| `filesystem` ★ ◇' | Both  | File system layout                   |
| `nix` ★ ◇         | Both  | Nix daemon & settings                |
| `user-cli` ◇      | Both  | User CLI setup                       |
| `user` ★          | Both  | User accounts & Home Manager wiring  |
| `security`        | Both  | Security & hardening                 |

### [`users`](./users)

The `core` Home Manager profiles `default` and `cli` compose the standard and
CLI base modules respectively.

### [`virt`](./virt)

| Module    | Type  | Description                 |
| --------- | ----- | --------------------------- |
| `android` | NixOS | Android virtualisation      |
| `docker`  | NixOS | Docker containers           |
| `libvirt` | Both  | Libvirt/QEMU virtualisation |
| `vfio`    | NixOS | VFIO GPU passthrough        |

### [`secrets`](../secrets)

| Module        | Type | Description        |
| ------------- | ---- | ------------------ |
| `secrets` ★ ◇ | Both | Secrets management |

## User Groups

Add needed groups to `users.users.<name>.extraGroups` in the host configuration.

| Module / feature   | Group(s)          | Purpose                                              |
| ------------------ | ----------------- | ---------------------------------------------------- |
| `security`, `nix`  | `wheel`           | Sudo and trusted Nix access                          |
| `filesystem`       | `keys`            | Edit the system configuration                        |
| `base`             | `networkmanager`  | Manage network connections                           |
| `printer`          | `scanner`, `lp`   | Scanners and multifunction printers                  |
| `docker`           | `docker`          | Docker without superuser privileges                  |
| `libvirt`          | `libvirtd`, `kvm` | VM management. `kvm` for direct QEMU/KVM access      |
| `vfio`             | `kvm`             | Looking Glass device access                          |
| `claude`           | `kvm`             | Cowork's local QEMU/KVM VM in Claude Desktop         |
| `network`          | `wireshark`       | Capture network traffic without superuser privileges |
| `mobile`           | `adbusers`        | Android USB access for ADB and `fastboot`            |
| `android`          | `android`         | Aqccess to persisted Waydroid data                   |
| `mc-server`        | `minecraft`       | Server files and command console access              |
| `games`            | `gamemode`        | GameMode's privileged helpers without authentication |
| `hyprland`, `niri` | `video`           | Backlight control through `brillo`                   |
| `gnome`            | `i2c`             | DDC/CI monitor control                               |
| Input tools        | `input`           | Raw input access                                     |
| System logs        | `systemd-journal` | Read system logs without superuser privileges        |

## Options

The following are the custom configuration options exposed by the modules above.

### NixOS

- [`apps`](./apps) -
  - `git` -
    - `package`: System `git` package - Ex. `pkgs.gitFull`
    - `hosting` -
      - `enable`: Enable Gitea Code Hosting - `true / false`
      - `domain`: Website Domain Name - Ex. `maydayv7.dev`
      - `secret`: Path to Cloudflare Authentication Credentials
    - `runner` -
      - `support`: Enable Support for `git` Runners - `null / "github" / "gitlab"`
      - `secret`: Path to Secret for `git` Runner
  - `wine` - Package to use for `wine` - Ex. `pkgs.wineWow64Packages.stagingFull`

- [`games`](./games) -
  - `mc-servers`: List of Minecraft Servers -
    - `name`: Unique server name
    - `type`: Server Type - `"fabric" / "skyblock"`
    - `memory`: Memory (GB) allocated to server - Ex. `12`
    - `config`: Server Properties (See [here](https://minecraft.fandom.com/wiki/Server.properties))
    - `port`: Main server TCP port - Ex. `25565`
    - `vc-port`: Port for [Simple Voice Chat](https://modrinth.com/plugin/simple-voice-chat) - Ex. `24454`

- [`gui`](./gui) -
  - `enable`: Enable Graphical Desktop Session - `true / false`
  - `fancy`: Enable Fancy GUI Effects - `true / false`
  - `display`: Main GUI Display - Ex. `"HDMI-A-1"`
  - `wallpaper`: Desktop Wallpaper Choice (taken from `files.wallpapers`)
  - `qt` -
    - `theme`: Qt application theme name
    - `package`: Qt theme package - Ex. `pkgs.adwaita-qt`

- [`hardware`](./hardware) -
  - `cpu` -
    - `model`: CPU Model - `"" / "amd" / "intel"`
    - `cores`: Number of CPU Cores - Ex. `4`
    - `mode`: CPU Frequency Governor Mode - `"ondemand" / "performance" / "powersave"`
  - `gpu` -
    - `enable`: Discrete GPU Support - `true / false`
    - `model`: Discrete GPU Model - `null / "nvidia"`

- [`system`](./system) -
  - `homeModules`: Home Manager modules shared by all configured users
  - `kernel`: Linux Kernel Variant to be used - `"lts"` or a suffix from `pkgs.linuxKernel.kernels`
  - `kernelModules`: Linux Kernel Modules to load
  - `scheme`: Supported Boot Firmware Scheme - `null / "mbr" / "efi" / "secure"`
  - `fs` -
    - `scheme`: Disk Filesystem Scheme - `null / "simple" / "advanced"`
    - `swap`: Size of SWAP Partition - Ex. `"8G"`
    - `disk`: Target Disk for Installation (Use `ls -l /dev/disk/by-id`) - Ex. `"/dev/disk/by-id/nvme-..."`
    - `persist`: Service files to preserve (across reboots with `advanced` FS scheme)
  - `nix` -
    - `index`: Enable Package Indexer - `true / false`
    - `tools`: Enable Additional Nix Tools - `true / false`

- `environment.persist`: System files to preserve (across reboots with `advanced` FS scheme)

- [`virt`](./virt) -
  - `vfio` -
    - `setup`: Enable VFIO Setup Mode - `true / false`
    - `passthrough`: PCI Device IDs for VFIO - Ex. `[ "10de:28e0" "10de:22be" ]`
    - `isolate`: Host CPU set to isolate for pinned vCPUs - Ex. `"2-4,10-12"`
    - `hugepages`: Number of 1 GiB hugepages to reserve - Ex. `16`

### Home Manager

- [`apps`](./apps) -
  - `obsidian.vault`: Path to notes vault (linked at `~/Documents/Notes`) - Ex. `/data/files/Sync/Notes`

- [`credentials`](./system/user) -
  - `name`: Work User Name
  - `fullname`: Full User Name
  - `mail`: User Mail ID - Ex. `"user@email.com"`
  - `key`: User GPG Key - Ex. `"CF616EB19C2765E4"`

- [`home.persist`](./system/filesystem.nix): User files to preserve (across reboots with `advanced` FS scheme)

- [Mutable files](./system/user/_mutable.nix) -
  - `home.file.<name>.mutable`
  - `xdg.configFile.<name>.mutable`
  - `xdg.dataFile.<name>.mutable`

  Set `mutable = true` and `force = true` to create a writable copy instead of a store symlink
