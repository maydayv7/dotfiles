<picture>
  <source media="(prefers-color-scheme: light)" srcset="files/images/logo/light.png"/>
  <source media="(prefers-color-scheme: dark)" srcset="files/images/logo/dark.png"/>
  <img alt="Logo" src="files/images/logo/dark.png">
</picture>

![License](https://img.shields.io/github/license/maydayv7/dotfiles?color=dgreen&style=flat-square) ![Size](https://img.shields.io/github/repo-size/maydayv7/dotfiles?color=red&label=size&style=flat-square) [![NixOS](https://img.shields.io/badge/NixOS-25.05-9cf.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

This [repository](https://github.com/maydayv7/dotfiles) contains the configuration and `dotfiles` for my continuously evolving multi-PC setup (using [Nix](https://nixos.org/)). All the devices I own, controlled by code. It also builds and deploys my website to [maydayv7.site](https://maydayv7.site). You can follow along with my [NixOS Desktop](https://maydayv7.site/series/nixos-desktop/) Series

<details>
<summary><b>Pictures</b></summary>

**_Note:_** These may be outdated

| ![Hyprland](./files/images/desktop/hyprland.jpg) |
| :----------------------------------------------: |
|                    _Hyprland_                    |

| ![GNOME Desktop](./files/images/desktop/gnome.jpg) |
| :------------------------------------------------: |
|                  _GNOME Desktop_                   |

| ![Pantheon Desktop](./files/images/desktop/pantheon.jpg) |
| :------------------------------------------------------: |
|                    _Pantheon Desktop_                    |

<details>
<summary>Theming</summary>

- [Starship](https://starship.rs/) Prompt Theme: Minimal, blazing-fast, and infinitely customizable prompt for any shell
- [Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor): Compact and material designed cursor set
- [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme): Pixel perfect icon theme for Linux
- [Catppuccin](https://github.com/catppuccin) Theme: A community-driven Pastel Theme consisting of 4 soothing warm Flavors with 26 eye-candy Colors each

- [Adwaita GTK3](https://github.com/lassekongo83/adw-gtk3): Theme from `libadwaita` ported to GTK3
- [KvLibadwaita](https://github.com/GabePoel/KvLibadwaita) Kvantum Theme: Integrates QT Apps with GNOME Desktop
- Firefox [GNOME Theme](https://github.com/rafaelmardojai/firefox-gnome-theme): GNOME Theme for the Mozilla Firefox Browser, used for better desktop integration
- VS Code [Adwaita Theme](https://github.com/piousdeer/vscode-adwaita): Integrates Visual Studio Code with GNOME Desktop
- Discord [DNOME](https://github.com/GeopJr/DNOME) Theme: Discord Theme inspired by Adwaita, designed to integrate Discord with GNOME

- Firefox [Elementary Theme](https://github.com/Zonnev/elementaryos-firefox-theme): Elementary OS Theme for the Mozilla Firefox Browser, used for better desktop integration
- VS Code [Elementary Theme](https://github.com/sixpounder/vscode-elementary-theme): Integrates Visual Studio Code with Pantheon Desktop
- Logseq [Bonofix Theme](https://github.com/Sansui233/logseq-bonofix-theme): A clean Logseq theme with focus on long-time writing experience

</details>

<details>
<summary><i>Older...</i></summary>

| [![XFCE Desktop](./files/images/desktop/xfce.jpg)](https://www.reddit.com/r/unixporn/comments/19efxry/xfce_functional_and_beautiful/) |
| :-----------------------------------------------------------------------------------------------------------------------------------: |
|                                                            _XFCE Desktop_                                                             |

| ![GNOME 45](./files/images/desktop/old/gnome_45.jpg) |
| :--------------------------------------------------: |
|                      _GNOME 45_                      |

| ![GNOME 44](./files/images/desktop/old/gnome_44.jpg) |
| :--------------------------------------------------: |
|                      _GNOME 44_                      |

| [![GNOME 41](./files/images/desktop/old/gnome_41.jpg)](https://www.reddit.com/r/unixporn/comments/ssb7mf/gnome_my_dream/) |
| :-----------------------------------------------------------------------------------------------------------------------: |
|                                                        _GNOME 41_                                                         |

</details>

</details>

## Features

<img alt="Built with Nix" src="https://raw.githubusercontent.com/nix-community/builtwithnix.org/62897617ceefe428f135e82c3a87ea093e29e045/img/built_with_nix.svg" width="130" height="50"/>

- Device-Agnostic
- Convenient and Automated
- Hermetically Reproducible
- Declarative and Derivational
- Atomic, Generational and Immutable

#### Notable Features

- Supports multiple users and devices
- Configuration for multiple Desktop Environments
- Incorporates PipeWire, Wayland, ...!
- Automatically builds and deploys my [Website](./site)
- Authentication Credentials Management using the [`sops`](https://github.com/Mic92/sops-nix) Module and [`gnupg`](https://gnupg.org/) Keys
- Comprehensive User Configuration using the tightly integrated [`home-manager`](https://github.com/nix-community/home-manager) module, with [support](./modules/user/default.nix) for configuring shared user configuration, global conditionals and user-specific configuration
- Ephemeral, Opt-In File System State using the [`impermanence`](https://github.com/nix-community/impermanence) module and [ZFS](https://zfsonlinux.org/)
- Support for Secure Boot using [`lanzaboote`](https://github.com/nix-community/lanzaboote)
- Support for Multiple Programming Language Development [`shells`](./shells) integrated with [`direnv`](https://direnv.net/) and [`lorri`](https://github.com/nix-community/lorri)
- Automatic `packages` Updates using [`update.sh`](./packages/update.sh)
- Syntax [Formatting](./modules/nix/format.nix) using [`treefmt`](https://github.com/numtide/treefmt) and [`treefmt-nix`](https://github.com/numtide/treefmt-nix)
- Support for `source` filters with [`nix-filter`](https://github.com/numtide/nix-filter)
- Support for Base16 color theming using [`stylix`](https://github.com/danth/stylix)
- Support for declaratively installing [Flatpak](./modules/apps/flatpak.nix) applications using [`nix-flatpak`](https://github.com/gmodena/nix-flatpak)
- Wrapped `wine` [Applications](./packages/wine) using Emmanuel's [Wrapper](https://github.com/emmanuelrosa/erosanix/tree/0dabea58d483e13d2de141517cb4ff1cb230b2aa/pkgs/mkwindowsapp)
- Support for Android Virtualisation using [Waydroid](https://waydro.id/)
- Support for VFIO PCI Device Passthrough along with [Looking Glass](https://looking-glass.io/) for high-performance VMs

## Programs

| Type     |                                                           Programs                                                           |
| :------- | :--------------------------------------------------------------------------------------------------------------------------: |
| Editors  | [`nano`](https://www.nano-editor.org/), [`micro`](https://micro-editor.github.io), [VS Code](https://code.visualstudio.com/) |
| Shells   |                          [`bash`](https://www.gnu.org/software/bash/), [`zsh`](https://www.zsh.org)                          |
| Terminal |                          [Ghostty](https://ghostty.org/), [Kitty](https://sw.kovidgoyal.net/kitty/)                          |
| Browser  |                                      [Firefox](https://www.mozilla.org/en-US/firefox/)                                       |
| Desktops |            [GNOME](https://www.gnome.org), [Hyprland](https://hyprland.org/), [Pantheon](https://elementary.io/)             |

## Structure

**_Overview of File Hierarchy_**

<details>
<summary><b>Outputs</b></summary>

```shellsession
$ nix flake show
github:maydayv7/dotfiles
├───apps
│   └───x86_64-linux
│       ├───hyprutils: app
│       ├───install: app
│       └───nixos: app
├───checks
│   └───x86_64-linux
│       ├───Device-iso: derivation 'nixos-rebuild'
│       └───treefmt: derivation 'treefmt-check'
├───devShells
│   └───x86_64-linux
│       ├───cc: development environment 'C'
│       ├───default: development environment 'devShell'
│       ├───format: development environment 'nix-shell'
│       ├───java: development environment 'Java'
│       ├───lua: development environment 'Lua'
│       ├───python: development environment 'Python'
│       ├───rust: development environment 'Rust'
│       ├───sql: development environment 'SQL'
│       ├───video: development environment 'Video'
│       └───website: development environment 'Website'
├───files: 'dotfiles' and program configuration
├───formatter
│   └───x86_64-linux: package 'treefmt'
├───legacyPackages
│   └───x86_64-linux (Default package channel)
├───lib: utility library functions
├───nixosConfigurations
│   ├───futura: NixOS configuration
│   ├───valkyrie: NixOS configuration
│   └───vortex: NixOS configuration
├───overlays
├───packages
│   └───x86_64-linux
│       ├───install: package 'os-install'
│       ├───nixos: package 'nixos'
│       └───website: package 'website-stable'
├───patchedPkgs: patched package source
├───systems: supported architectures
└───templates
    └───default: template: My NixOS Configuration
```

</details>

```
┌── flake.nix
├── flake.lock
├── files
├── site
├── devices
│   └── vm
├── users
│   └── passwords
├── secrets
├── shells
├── checks
├── lib
│   ├── build.nix
│   ├── map.nix
│   └── pack.nix
├── scripts
│   ├── install.nix
│   └── nixos.nix
├── packages
│   └── overlays
└── modules
    ├── configuration.nix
    ├── apps
    ├── base
    ├── gui
    ├── hardware
    ├── nix
    ├── shell
    └── user
```

- `flake.nix`: toplevel configuration file and repository version control  
  [`flake-parts`](https://github.com/hercules-ci/flake-parts) is used for modularization

- [`files`](./files/README.md): `dotfiles` and program configuration
- [`site`](./site/README.md): personal website generated using [`zola`](https://www.getzola.org/)
- [`devices`](./devices/README.md): system configuration for various devices
- [`vm`](./devices/vm/README.md): declarative configuration to build multiple virtual machines
- [`users`](./users/README.md): individual user-specific configuration
- [`secrets`](./secrets/README.md): authentication credentials management using [`sops-nix`](https://github.com/Mic92/sops-nix)
- `shells`: sand-boxed shells for development purposes
- `checks`: configuration checks and continuous integration
- [`lib`](./lib/README.md): custom functions designed for conveniently defining configuration
- [`scripts`](./scripts/README.md): useful system management scripts
- [`packages`](./packages/README.md): locally built custom packages
- `overlays`: overrides for pre-built packages
- [`modules`](./modules/README.md): custom configuration modules for additional functionality
- `configuration.nix`: builds system configuration

## Installation

<details>
<summary><b>Already Installed</b></summary>

In case you want to use my configuration as-is for a fresh NixOS install, you can try the following steps:

**_Note:_** You can run `nix develop` in the repository to install all required dependencies

1. Prepare `/etc/nixos`: <pre><code>sudo mkdir /etc/nixos
   sudo chown $USER /etc/nixos && sudo chmod ugo+rw /etc/nixos
   cd /etc/nixos
   </code></pre>

2. Clone this repository (and preferably initialize it using `git`): <pre><code>nix flake init -t github:maydayv7/dotfiles
   git init
   </code></pre>

3. Install `gnupg` and generate a GPG Key for yourself (if you don't already have one), and include it in the [`secrets.yaml`](./secrets/secrets.yaml) file (using `gpg --list-keys`). You can use the following commands to generate the GPG key (Ultimate trust and w/o passphrase is preferred):  
   _Replace_ **_USER_** _,_ **_EMAIL_** _and_ **_COMMENT_** <pre><code>gpg --full-generate-key
   1
   4096
   0
   y
   <b><i>USER
   EMAIL
   COMMENT</i></b>
   O
   gpg --output public.pgp --armor --export <b><i>USER</i></b>@<b><i>EMAIL</i></b>
   gpg --output private.pgp --armor --export-secret-key <b><i>USER</i></b>@<b><i>EMAIL</i></b>
   </code></pre>
   _Save the keys `public.gpg` and `private.gpg` in a secure location_

4. Import all required GPG Keys into a convenient location (like `/etc/gpg`) using <code>gpg --homedir <i>DIR</i> import</code> and specify it at `config.sops.gnupg.home` (Required for decryption of `secrets` on boot, can also be on an external drive)

5. Make new `secrets` and `passwords` in the desired directories by appending the paths to `secrets.yaml` and then using the following command (The [`nixos`](./scripts/README.md) script can be used to simplify the process):  
   _Replace_ **_PATH_** _with the path to the `secret`_ <pre><code>sops --config <i>/path/to/<b>secrets.yaml</b></i> -i <b><i>PATH</i></b></code></pre>

6. Add device-specific configuration by creating a new file in [`devices`](./devices) (bear in mind that the name of the file must be same as the `HOSTNAME` of your device), and if required, hardware configuration using the `hardware.modules` option. Do keep in mind that the filesystems must be appropriately created and labeled as defined [here](./modules/hardware/filesystem.nix).

7. Finally, run `nixos-rebuild switch --flake /etc/nixos#HOSTNAME` (as `root`) to switch to the configuration!

</details>

<details>
<summary><b>Minimal Configuration</b></summary>

The `lib.build.device` function can be used to generate the full configuration minimally  
Read [this](./devices/README.md) for definition information

Example `flake.nix`:

```nix
{
  description = "Minimal NixOS Configuration";

  ## System Repositories ##
  inputs = {
    ## Package Repositories ##
    # NixOS Package Repository
    nixpkgs.follows = "dotfiles/nixpkgs";

    ## Configuration Modules ##
    # My PC Dotfiles
    dotfiles.url = "github:maydayv7/dotfiles";
  };

  ## System Configuration ##
  outputs = inputs: let
    lib = with inputs; nixpkgs.lib // dotfiles.lib;
  in {
    nixosConfigurations.host = lib.build.device {
      name = "HOST_NAME";
      system = "x86_64-linux";

      imports = [
        # Generate using 'nixos-generate-config'
        ./hardware-configuration.nix

        # Passwords
        {
          users.extraUsers = {
            root.hashedPassword = "HASHED_PASSWORD";
            recovery.initialHashedPassword = "HASHED_PASSWORD";
          };
        }
      ];

      timezone = "Continent/City";
      locale = "US";

      kernel = "lts";
      kernelModules = ["nvme"];

      gui = {};
      hardware = {
        boot = "efi";
        cores = 4;
        filesystem = "simple";
        modules = [ /* Imported from 'nixos-hardware' */];
      };

      # Default User
      user = {
        name = "nixos";
        description = "Default User";
        minimal = true;
        password = "HASHED_PASSWORD"; # Generate using 'mkpasswd -m sha-512'
      };
    };
  };
}
```

</details>

<details>
<summary><b>From Scratch</b></summary>

> [!IMPORTANT]
> These instructions are mainly intended for personal use

To download the Install Media, click on the latest successsful run listed [here](../../actions/workflows/installer.yml) and download the image artifact. Burn it to a USB using a flashing utility such as [Etcher](https://www.balena.io/etcher/)

> [!TIP]
> In order to directly use the configuration, you must first create a clone of this repository and follow steps 2 to 6 from the first section, and preferably create your own install media

<details>
<summary><i>Build</i></summary>
If Nix is already installed on your system, you may run the following command to build the Install Media image:

<pre><code>nix build github:maydayv7/dotfiles#nixosConfigurations.install.config.system.build.images.iso</code></pre>

To build and run the `install` script, use the following commands:

```
nix build github:maydayv7/dotfiles#install
sudo ./result/bin/os-install
```

If you want to create an `.iso` image of the entire system, run the following command:  
_Replace_ **_DEVICE_** _with the name of Device to build_

<pre><code>nix build github:maydayv7/dotfiles#nixosConfigurations.<b><i>DEVICE</i></b>.config.system.build.images.iso</code></pre>

</details>

#### Partition Scheme

_Note that the `install` script automatically creates and labels all the required partitions, so it is recommended that only the partition table on the disk be created and have enough free space_

| Name           | Label  | Format | Size (minimum) |
| :------------- | :----: | :----: | :------------: |
| BOOT Partition |  ESP   |  vfat  |      500M      |
| ROOT Partition | System |  ZFS   |      25G       |
| SWAP Area      |  swap  |  swap  |       4G       |
| DATA Partition | Files  |  ZFS   |      10G       |

> [!NOTE]
> For the `advanced` filesystem scheme only

#### Procedure

To install the OS, just boot the Live USB and run `sudo os-install`  
_If the image doesn't boot, try disabling the `secure boot` and `RAID` options from `BIOS`_  
After the reboot, run `nixos setup` to finish the install  
_In case you are using the `advanced` filesystem scheme, you may need to set the boot flag `zfs_force=1` on first boot_

</details>

<details>
<summary><b>Build It Yourself</b></summary>

If you really want to get dirty with Nix and decide to invest oodles of your time into building your own configuration, this repository can be used as inspiration. You can check out the list of links below to resourceful Nix documentation/tutorials/projects that may be helpful in your endeavour

**Welcome** to the Nix Community! ;)

</details>

## Notes

### Caution

This repository contains my personal configuration, and may cause undesirable effects on other systems. It may also be subject to rapid undocumented changes, and uses Nix [Flakes](https://wiki.nixos.org/wiki/Flakes), an experimental feature

> [!NOTE]
> Required Nix Version >= 2.19

It is not recommended to use NixOS if you are a beginner just starting out, without acquaintance with either the command-line or functional programming languages, since the learning curve is steep, debugging issues is difficult, documentation is shallow, and the effort required/time spent isn't worth the hassle for a novice/casual user

### Platform

_May change according to available hardware_

This configuration works well with an Intel CPU + iGPU, and is currently being improved to support AMD APU + Nvidia GPU. Any other setup is untested  
The `hardware.modules` option can be used to load relevant configuration from [`nixos-hardware`](https://github.com/nixos/nixos-hardware)

See [this](./modules/hardware/README.md) for additional information

### Build

While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty

#### Cache

The system build cache is publicly hosted using [Cachix](https://www.cachix.org) at [maydayv7-dotfiles](https://app.cachix.org/cache/maydayv7-dotfiles), and can be used while building the system to prevent rebuilding from scratch

#### Continuous Integration

This repository makes use of [`GitHub Actions`](./checks/github/workflows) in order to automatically check the configuration syntax on every commit and format it (using [`treefmt-nix`](https://github.com/numtide/treefmt-nix)), update the `inputs` and build the Install Media `.iso` every month, and upload the build cache to [Cachix](https://app.cachix.org/cache/maydayv7-dotfiles) (You can also find `GitLab CI/CD` configuration in [`.gitlab`](./checks/gitlab/.gitlab-ci.yml)). A `git` [hook](./.git-hooks) is used to check the commit message to adhere to the [`Conventional Commits`](https://www.conventionalcommits.org) specification

###### Variables

- [`ACCESS_TOKEN`](./secrets/github-token.secret): Personal Access Token (To create one - [GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token), [GitLab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html))
- [`CACHIX_TOKEN`](./secrets/cachix-token.secret): Cachix Authentication Token

### Home Manager

The [`home-manager`](https://github.com/nix-community/home-manager) module is used in tandem with the system configuration in order to define user-specific configuration. The `config.user.homeConfig` option, from which the final user configuration is built, has been declared in [`modules/user/default.nix`](./modules/user/default.nix) in order to effortlessly configure shared configuration for all users of the system. The system `config` can be accessed using the `sys` parameter in `home-manager` modules

## Links

**See:** A [Curated List](https://github.com/nix-community/awesome-nix) of the Best Resources in the Nix Community  
**Also:** [This](https://nixos-and-flakes.thiscute.world/) website for beginners starting out with NixOS and Flakes

- Official [Documentation](https://nixos.org/learn.html)
- NixOS [Manual](https://nixos.org/manual/nixpkgs/stable)
- Nix [Pills](https://nixos.org/guides/nix-pills/)
- NixOS [Discourse](https://discourse.nixos.org/)
- NixOS [Package Search](https://search.nixos.org/)
- [`nixpkgs`](https://github.com/NixOS/nixpkgs) Package Repository
- [NUR](https://github.com/nix-community/NUR) Nix User Repository
- NixOS [Hardware Modules](https://github.com/nixos/hardware)
- Home Manager [Options](https://nix-community.github.io/home-manager/options.html)

### Other Sources

- Tweag [Article](https://www.tweag.io/blog/2020-05-25-flakes/) introducing Flakes
- Serokell's [Blog](https://serokell.io/blog/practical-nix-flakes) on Flakes
- Jordan Isaac's [Blog](https://jdisaacs.com/series/nixos-desktop/) for porting configuration to Flakes
- Jon Ringer's [Videos](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ) on General NixOS Tooling and Hackery
- Justin's [Notes](https://github.com/justinwoo/nix-shorts) on using Nix
- Lan Tian's Series of [Blog Posts](https://lantian.pub/en/article/modify-website/nixos-initial-config-flake-deploy.lantian/) on NixOS
- Christine's [Blog Posts](https://christine.website/blog/series/nixos) addressing NixOS Security
- [Graham's](https://grahamc.com/blog/erase-your-darlings) and [Elis'](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) Blog Posts on Ephemeral Partition Schemes

### Other Configurations

Here are some repositories that I may have shamelessly rummaged through for building my `dotfiles`:  
_Thanks a lot! ;)_

- Example [Configuration](https://github.com/srid/nixos-flake)
- User Configurations -
  - [4JX](https://github.com/4JX/nixos-config)
  - [balsoft](https://code.balsoft.ru/balsoft/nixos-config)
  - [bbigras](https://github.com/bbigras/nix-config)
  - [cole-h](https://github.com/cole-h/nixos-config/)
  - [colemickens](https://github.com/cole-mickens/nixcfg)
  - [davidtwco](https://github.com/davidtwco/veritas)
  - [fufexan](https://github.com/fufexan/dotfiles)
  - [gvolpe](https://github.com/gvolpe/nix-config)
  - [hlissner](https://github.com/hlissner/dotfiles)
  - [jordanisaacs](https://github.com/jordanisaacs/dotfiles)
  - [kclejeune](https://github.com/kclejeune/system)
  - [lovesegfault](https://github.com/lovesegfault/nix-config)
  - [lucasew](https://github.com/lucasew/nixcfg)
  - [nobbz](https://github.com/NobbZ/nixos-config)
  - [rasendubi](https://github.com/rasendubi/dotfiles)
  - [sioodmy](https://github.com/sioodmy/dotfiles)
  - [tejing1](https://github.com/tejing1/nixos-config)
  - [vlaci](https://github.com/vlaci/nixos-config)
  - [wiltaylor](https://github.com/wiltaylor/dotfiles)
  - [wimpysworld](https://github.com/wimpysworld/nix-config)

---

<details>
<summary><b>Known Limitations</b></summary>

- Home Configuration isn't decoupled from System

### Manual Intervention

- Online accounts have to be manually signed into
- [Wine](./packages/wine) Applications have to be manually updated
- Logseq Plugins have to be manually installed
- Cannot automatically hibernate on NVIDIA due to upstream [issue](https://forums.developer.nvidia.com/t/systemds-suspend-then-hibernate-not-working-in-nvidia-optimus-laptop/213690)

### To Do

- VFIO Support via GPU Hotplug instead of restart

</details>

> Last Updated: **May** 2025

If you like this project, consider leaving a [star](https://github.com/maydayv7/dotfiles)

**V 7**  
<maydayv7@gmail.com>
