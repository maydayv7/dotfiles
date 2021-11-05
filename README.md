# Dotfiles
![Version](https://img.shields.io/github/v/release/maydayv7/dotfiles?include_prereleases&label=version&style=flat-square&logo=github) ![License](https://img.shields.io/github/license/maydayv7/dotfiles?color=dgreen&style=flat-square) ![Size](https://img.shields.io/github/repo-size/maydayv7/dotfiles?color=red&label=size&style=flat-square)  
This repo contains the configuration files for my continuously evolving multi-PC setup

## OS
**NixOS** 21.05  

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![](./notes/resources/desktop.png)

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
Please see the [notes](./notes/README.md) directory for additional information about my dotfiles
