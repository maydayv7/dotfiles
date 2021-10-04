# My PC Dotfiles
![Version](https://img.shields.io/github/v/release/maydayv7/dotfiles?include_prereleases) ![Issues](https://img.shields.io/github/issues/maydayv7/dotfiles) ![Size](https://img.shields.io/github/repo-size/maydayv7/dotfiles)  
This repo contains the configuration files for my continuously evolving multi-PC setup
## OS
**NixOS** 21.05  

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![desktop](./.src/desktop.png)

## Programs
| Type                | Program                     |
| :------------------ | :-------------------------: |
| Editor              | [gEdit](https://wiki.gnome.org/Apps/Gedit) |
| Shell               | [ZSH](https://www.zsh.org) |
| Terminal            | [GNOME Terminal](https://gitlab.gnome.org/GNOME/gnome-terminal) |
| Desktop Environment | [GNOME](https://www.gnome.org) |

## Structure

Here is an overview of the file hierarchy:

```
┌── flake.nix
├── flake.lock
├── secrets
├── users
│   └── dotfiles
├── modules
│   └── core
├── packages
└── lib
    ├── host.nix
    └── user.nix
```

- `flake.nix`: main system configuration file, using [Flakes](https://nixos.wiki/wiki/Flakes) for easier repository version control and multi-device management
- `modules`: modulated configuration for effortless management
- `core`: shared system configuration and scripts
- `packages`: overrides for pre-built packages and locally built custom packages
- `users`: user related configuration and dotfiles

## Installation
Install NixOS using the following commands:  
*Note that the partition label along with the `esp` and `boot` flags must be set on the EFI System Partition*
<pre><code>mkfs.ext4 -L System <i>/path/to/root</i>
mkswap -L swap <i>/path/to/swap</i>
mkfs.fat -F 32 -n boot <i>/path/to/esp</i>
mount /dev/disk/by-label/System /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-partlabel/boot /mnt/boot/efi
nixos-generate-config --root /mnt
nixos-install
</code></pre>

After rebooting, run the following commands:
<pre><code>sudo rm -rf /etc/nixos && cd /etc
sudo mkdir nixos && sudo chown $USER ./nixos && sudo chmod ugo+rw ./nixos
git clone --recurse-submodules https://github.com/maydayv7/dotfiles.git nixos
cd nixos && chmod +x .setup.sh && ./.setup.sh
</code></pre>
And follow the instructions to setup and build the system

## Notes
#### Caution
I am pretty new to Nix, and my configuration is still *WIP*, right now undergoing a transition to using Nix [Flakes](https://nixos.wiki/wiki/Flakes), an unstable feature. If you have any doubts or suggestions, feel free to open an issue

#### Branches
There are two branches, `stable` and `develop`. The `stable` branch can be used at any time, and consists of configuration that builds without failure, but the `develop` branch is a bleeding-edge testbed, and may not even build successfully. Releases are always made from the `stable` branch after it has been battle-tested

#### Requirements
- Intel CPU + iGPU
- UEFI System (for use with GRUB EFI Bootloader)

#### System Management
##### Data Storage
User files are stored on an NTFS partition mounted to `/data`
##### Build
While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty
##### Credentials
The `secrets` directory is a `git submodule` pointing to a private repository containing passwords and other authentication credentials. User passwords are specified using the `passwordFile` option
##### Scripts
A system management script has been included in `modules/core/scripts.nix` and can be invoked with the command `nixos`, used to apply user and system configuration changes or to perform various other useful functions. Also, a system setup script has been included (see the Installation section)

#### Theming
- [Neofetch](https://github.com/dylanaraps/neofetch): Snazzy CLI System Information Tool
- [Powerlevel10K](https://github.com/romkatv/powerlevel10k): P10K ZSH Theme for the fancy-looking prompt using custom configuration
- [Firefox GNOME Theme](https://github.com/rafaelmardojai/firefox-gnome-theme): GNOME Theme for the Mozilla Firefox Browser, used for better desktop integration, `git submodule` imported at `users/firefox/theme/firefox-gnome-theme`
- [DNOME Discord Theme](https://github.com/GeopJr/DNOME): Discord theme inspired by Adwaita, designed to integrate Discord with GNOME

#### Important Links
- [NixOS Manual](https://nixos.org/manual/nixpkgs/stable)
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Package Search](https://search.nixos.org/)
- [Nixpkgs Repository](https://github.com/NixOS/nixpkgs)
- [Nix User Repository](https://github.com/nix-community/NUR)
- [Home Manager Options](https://rycee.gitlab.io/home-manager/options.html)
