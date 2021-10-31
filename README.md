# My PC Dotfiles
![Version](https://img.shields.io/github/v/release/maydayv7/dotfiles?include_prereleases&label=version&style=flat-square&logo=github) ![License](https://img.shields.io/github/license/maydayv7/dotfiles?color=dgreen&style=flat-square) ![Size](https://img.shields.io/github/repo-size/maydayv7/dotfiles?color=red&label=size&style=flat-square)  
This repo contains the configuration files for my continuously evolving multi-PC setup

## OS
**NixOS** 21.05  

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![](./src/images/desktop.png)

## Programs
| Type                | Program                     |
| :------------------ | :-------------------------: |
| Editor              | [gEdit](https://wiki.gnome.org/Apps/Gedit) |
| Shell               | [ZSH](https://www.zsh.org) |
| Terminal            | [GNOME Terminal](https://gitlab.gnome.org/GNOME/gnome-terminal) |
| Browser             | [Firefox](https://www.mozilla.org/en-US/firefox/) |
| Desktop Environment | [GNOME](https://www.gnome.org) |

## Structure

Here is an overview of the file hierarchy:

```
┌── flake.nix
├── flake.lock
├── scripts
│   └── setup.sh
├── packages
│   └── overlays
├── lib
│   ├── device.nix
│   └── user.nix
├── roles
│   ├── device
│   └── user
└── modules
    ├── device
    ├── iso
    └── user
```

- `flake.nix`: main system configuration file, using [Flakes](https://nixos.wiki/wiki/Flakes) for easier repository version control and multi-device management
- `packages`: locally built custom packages
- `overlays`: overrides for pre-built packages
- `lib`: custom functions designed for conveniently defining device and user configuration
- `roles`: modulated role-based configuration for effortless management
- `modules`: custom-made configuration modules for additional functionality
- `device`: shared device configuration and scripts
- `iso`: resources for creation of install media
- `user`: user related configuration and dotfiles

## Installation
Download the NixOS `.iso` from the [Releases](https://github.com/maydayv7/dotfiles/releases/latest) page, then burn it to a USB using [Etcher](https://www.balena.io/etcher/). If Nix is already installed on your system, you may run the following command to build the `.iso`:  
*Replace* ***VARIANT*** *with the name of install media to create*
```
nix build github:maydayv7/dotfiles#installMedia.VARIANT.config.system.build.isoImage
```

#### Partition Scheme
*Note that the `install` script automatically creates and labels all the required partitions, so it is recommended that only the partition table on the disk be created and have enough free space*

| Name           | Label  | Format     | Size (minimum) |
| :------------- | :----: | :--------: | :------------: |
| BOOT Partition | ESP    | vfat       | 500M           |
| ROOT Partition | System | ext4/BTRFS | 25G            |
| SWAP Area      | swap   | swap       | 8G             |
| DATA Partition | Files  | NTFS       | 10G            |

#### Procedure
To install the OS, just boot the Live USB and run `sudo install`  
*In case it doesn't boot, try disabling the `secure boot` and `RAID` options from `BIOS`*  
After the reboot, run `setup` in the newly installed system to finish setup

## Notes
#### Caution
I am pretty new to Nix, and my configuration is still *WIP*, right now undergoing a transition to using Nix [Flakes](https://nixos.wiki/wiki/Flakes), an unstable feature. If you have any doubts or suggestions, feel free to open an issue

#### Branches
There are two branches, `stable` and `develop`. The `stable` branch can be used at any time, and consists of configuration that builds without failure, but the `develop` branch is a bleeding-edge testbed, and is not recommended to be used. Releases are always made from the `stable` branch after it has been extensively tested

#### Requirements
- Intel CPU + iGPU
- UEFI System (for use with GRUB EFI Bootloader)

#### Device Management
##### Data Storage
User files are stored on an NTFS partition mounted to `/data`

##### Build
While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty

##### Cache
The system build cache is publicly hosted using [Cachix](https://www.cachix.org) at [maydayv7-dotfiles](https://app.cachix.org/cache/maydayv7-dotfiles), and can be used while building the system to prevent rebuilding from scratch

##### Credentials
The authentication credentials are stored in a private repository containing passwords and other security keys, which is imported into the configuration as an `input`, and cloned using the `Github` authentication token. User passwords are made using the command `mkpasswd -m sha-512` and are specified using the `hashedPassword` option

##### Scripts
A system management script invoked with the command `nixos` has been included, which can be used to apply user and device configuration changes or perform various other useful functions. The `install` and `setup` scripts have also been included to painlessly install the OS and setup the device, using a single command

##### File System
These configuration files can be used to setup the system using either ext4 or BTRFS (with opt-in state). The opt-in state (using TMPFS for `/`) allows for a vastly improved experience, preventing any cruft to form and exerting total control over the device state, by erasing the system at every boot, keeping only what's required/defined

#### Theming
- [Neofetch](https://github.com/dylanaraps/neofetch): Snazzy CLI System Information Tool
- [Powerlevel10K](https://github.com/romkatv/powerlevel10k): ZSH Theme for the fancy-looking prompt with immense customization capabilities
- [Dash to Panel](https://github.com/home-sweet-gnome/dash-to-panel): GNOME Shell Extension providing a highly customizable icon taskbar for maximized productivity (personal [fork](https://github.com/maydayv7/dash-to-panel))
- [DNOME Discord Theme](https://github.com/GeopJr/DNOME): Discord theme inspired by Adwaita, designed to integrate Discord with GNOME
- [Firefox GNOME Theme](https://github.com/rafaelmardojai/firefox-gnome-theme): GNOME Theme for the Mozilla Firefox Browser, used for better desktop integration

#### Important Links
- [NixOS Manual](https://nixos.org/manual/nixpkgs/stable)
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Package Search](https://search.nixos.org/)
- [Nixpkgs Repository](https://github.com/NixOS/nixpkgs)
- [Nix User Repository](https://github.com/nix-community/NUR)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Impermanence Module](https://github.com/nix-community/impermanence)
