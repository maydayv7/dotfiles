# Configuration Modules

The `modules` directory contains the custom configuration modules that form the very core of my configuration for multiple PCs and various use-cases, that follows the [dendritic](https://github.com/mightyiam/dendritic) pattern:

- Directories are purely organizational
- Files prefixed with `_` are not auto-imported
- [`core`](./core): `flake-parts` plumbing that wires everything together
- [`hosts`](./hosts): per-device configuration, declared as `configurations.nixos.<host>` and `configurations.homeManager.<user@host>`, composing the modules below
- [`users`](./users/): user-specific Home Manager configurations

## Module List

An overview of every configuration module in this repository.

**Type** indicates whether a module extends `flake.modules.nixos`, `flake.modules.homeManager`, or both.

**★** marks modules imported by default

### [`apps`](./apps)

| Module        | Type         | Description                        |
| ------------- | ------------ | ---------------------------------- |
| `auth`        | Home Manager | Authentication credential managers |
| `discord`     | Home Manager | Discord chat client                |
| `firefox`     | Home Manager | Firefox browser                    |
| `internet`    | Home Manager | Internet apps                      |
| `notes`       | Home Manager | Logseq note-taking                 |
| `spotify`     | Home Manager | Spotify music client               |
| `stream`      | Home Manager | Streaming tools                    |
| `syncthing`   | Home Manager | Syncthing file sync                |
| `youtube`     | Home Manager | YouTube Music & TUI                |
| `vscode`      | Home Manager | Visual Studio Code editor          |
| `flatpak`     | Both         | Flatpak app sandboxing             |
| `latex`       | Both         | LaTeX typesetting                  |
| `office`      | Both         | Office suite environment           |
| `tools`       | Both         | General CLI/GUI tools              |
| `wine`        | Both         | Wine Windows compatibility         |
| `git`         | Both         | `git` version control              |
| `git-hosting` | NixOS        | Gitea code hosting                 |
| `git-runner`  | NixOS        | GitHub/GitLab CI runner            |

### [`desktop`](./desktop)

| Module     | Type | Description               |
| ---------- | ---- | ------------------------- |
| `gnome`    | Both | GNOME desktop environment |
| `hyprland` | Both | Hyprland window manager   |

### [`games`](./games)

| Module      | Type         | Description                        |
| ----------- | ------------ | ---------------------------------- |
| `games`     | Both         | Gaming environment (Lutris, Steam) |
| `minecraft` | Home Manager | Minecraft client                   |
| `osu`       | Home Manager | osu! rhythm game                   |
| `mc-server` | NixOS        | Minecraft server                   |
| `roblox`    | NixOS        | Roblox client                      |

### [`gui`](./gui)

| Module    | Type  | Description         |
| --------- | ----- | ------------------- |
| `theme` ★ | Both  | System-wide theming |
| `fonts` ★ | NixOS | System fonts        |
| `gtk`     | Both  | GTK theming         |
| `qt`      | Both  | Qt theming          |

### [`hardware`](./hardware)

| Module       | Type  | Description         |
| ------------ | ----- | ------------------- |
| `cpu` ★      | NixOS | CPU configuration   |
| `gpu` ★      | NixOS | GPU configuration   |
| `laptop`     | Both  | Laptop tweaks       |
| `mouse`      | Both  | Mouse configuration |
| `mobile`     | NixOS | Mobile firmware     |
| `printer`    | NixOS | Printer firmware    |
| `blockchain` | NixOS | Blockchain support  |

### [`shell`](./shell)

| Module        | Type  | Description         |
| ------------- | ----- | ------------------- |
| `shell` ★     | Both  | Shell configuration |
| `shell-utils` | Both  | Shell utilities     |
| `prompt`      | NixOS | Shell prompt        |

### [`system`](./system)

| Module       | Type  | Description                         |
| ------------ | ----- | ----------------------------------- |
| `base` ★     | Both  | Base system configuration           |
| `nix` ★      | Both  | Nix daemon & settings               |
| `user` ★     | Both  | User accounts & Home Manager wiring |
| `filesystem` | Both  | File system layout                  |
| `base-ext`   | NixOS | Extended base configuration         |
| `boot`       | NixOS | Boot loader configuration           |
| `security`   | NixOS | Security & hardening                |

### [`virt`](./virt)

| Module    | Type  | Description                 |
| --------- | ----- | --------------------------- |
| `libvirt` | Both  | Libvirt/QEMU virtualisation |
| `android` | NixOS | Android virtualisation      |
| `docker`  | NixOS | Docker containers           |
| `vfio`    | NixOS | VFIO GPU passthrough        |

### [`secrets`](../secrets)

| Module      | Type  | Description        |
| ----------- | ----- | ------------------ |
| `secrets` ★ | NixOS | Secrets management |

## Options

The following are the custom configuration options exposed by the modules above:

- [`apps`](./apps) -
  - `git` -
    - `hosting` -
      - `enable`: Enable Gitea Code Hosting - `true / false`
      - `domain`: Website Domain Name - Ex. `maydayv7.cc`
      - `secret`: Path to Cloudflare Authentication Credentials
    - `runner` -
      - `support`: Enable Support for `git` Runners - `null / "github" / "gitlab"`
      - `secret`: Path to Secret for `git` Runner
  - `wine` -
    - `utilities`: Install Utility Windows apps - `true / false`
    - `package`: Package to use for `wine` - Ex. `pkgs.wineWow64Packages.stagingFull`

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

- [`hardware`](./hardware) -
  - `cpu` -
    - `model`: CPU Model - `"" / "amd" / "intel"`
    - `cores`: Number of CPU Cores - Ex. `4`
    - `mode`: CPU Frequency Governor Mode - `"ondemand" / "performance" / "powersave"`
  - `gpu` -
    - `enable`: Discrete GPU Support - `true / false`
    - `model`: Discrete GPU Model - `null / "nvidia"`

- [`system`](./system) -
  - `kernel`: Linux Kernel Variant to be used - `"lts" / "variant"`
  - `kernelModules`: Linux Kernel Modules to load
  - `scheme`: Supported Boot Firmware Scheme - `null / "mbr" / "efi" / "secure"`
  - `fs` -
    - `scheme`: Disk Filesystem Scheme - `null / "simple" / "advanced"`
    - `persist`: System Files to preserve across reboots (while using the `advanced` File System Layout)
  - `nix` -
    - `index`: Enable Package Indexer - `true / false`
    - `tools`: Enable Additional Nix Tools - `true / false`

- [`virt`](./virt) -
  - `vfio` -
    - `setup`: Enable VFIO Setup Mode - `true / false`
    - `passthrough`: PCI Device IDs for VFIO - Ex. `[ "10de:28e0" "10de:22be" ]`

- [`user`](./system/user) -
  - `credentials`: Individual User Credentials -
    - `name`: Alternative (Work) User Name
    - `fullname`: Full User Name
    - `mail`: User Mail ID - Ex. `"user@email.com"`
    - `key`: User GPG Key - Ex. `"CF616EB19C2765E4"`
