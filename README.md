# My PC Dotfiles
![Version](https://img.shields.io/github/v/release/maydayv7/dotfiles?include_prereleases&label=version&style=flat-square&logo=github) ![License](https://img.shields.io/github/license/maydayv7/dotfiles?color=dgreen&style=flat-square) ![Size](https://img.shields.io/github/repo-size/maydayv7/dotfiles?color=red&label=size&style=flat-square)  
This repo contains the configuration files for my continuously evolving multi-PC setup

## OS
**NixOS** 21.05  

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

![desktop](./src/desktop.png)

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
├── secrets
├── scripts
│   └── setup.sh
├── users
│   └── dotfiles
├── modules
│   └── core
├── packages
│   └── overlays
└── lib
    ├── host.nix
    └── user.nix
```

- `flake.nix`: main system configuration file, using [Flakes](https://nixos.wiki/wiki/Flakes) for easier repository version control and multi-device management
- `modules`: modulated configuration for effortless management
- `core`: shared system configuration and scripts
- `overlays`: overrides for pre-built packages
- `packages`: locally built custom packages
- `users`: user related configuration and dotfiles

## Installation
Download the latest NixOS .iso from [here](https://nixos.org/download.html), then either burn it to a USB using [Etcher](https://www.balena.io/etcher/) or a CD using [Brasero](https://wiki.gnome.org/Apps/Brasero), and boot the LiveCD  
*In case it doesn't boot, disable `secure boot` and `RAID` from `BIOS`*

#### Partition Scheme
Partition the drive using a tool such as [Gparted](https://gparted.org/)  
*Note that partition labels must be set on all the partitions, along with the `esp` and `boot` flags on the ESP*

| Name           | Label  | Format     | Size (minimum) |
| :------------- | :----: | :--------: | :------------: |
| BOOT Partition | ESP    | vfat       | 500M           |
| ROOT Partition | System | ext4/BTRFS | 25G            |
| SWAP Area      | swap   | swap       | 4G             |
| DATA Partition | Files  | NTFS       | 10G            |

#### Commands
Then, install the OS using the following commands:  
<pre><code>sudo -i
nix-env -iA nixos.nixUnstable
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
mkswap -L swap <i>/path/to/swap</i>
mount /dev/disk/by-label/System /mnt
</pre></code>

##### BTRFS
```console
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/lib
umount /mnt
mkdir /mnt/{home,nix,persist,var,var/log,var/lib}
mount -o subvol=home,compress=zstd,autodefrag,noatime /dev/disk/by-label/System /mnt/home
mount -o subvol=nix,compress=zstd,autodefrag,noatime /dev/disk/by-label/System /mnt/nix
mount -o subvol=persist,compress=zstd,autodefrag,noatime /dev/disk/by-label/System /mnt/persist
mount -o subvol=log,compress=zstd,autodefrag,noatime /dev/disk/by-label/System /mnt/var/log
mount -o subvol=lib,compress=zstd,autodefrag,noatime /dev/disk/by-label/System /mnt/var/lib
```

<pre><code>mkdir -p /mnt/boot
mount /dev/disk/by-partlabel/ESP /mnt/boot
nixos-install --no-root-passwd --flake github:maydayv7/dotfiles#<i>host</i>
reboot now
</pre></code>

#### Post Install
##### ext4
```
sudo rm -rf /etc/nixos
cd /etc
sudo mkdir nixos && sudo chown $USER ./nixos && sudo chmod ugo+rw ./nixos
```

##### BTRFS
```console
sudo rm -rf /etc/nixos
sudo mkdir -p /persist/etc/{nixos,NetworkManager}
sudo mv /etc/machine-id /persist/etc/machine-id
sudo mv /etc/NetworkManager/system-connections /persist/etc/NetworkManager/system-connections
cd /persist/etc && sudo chown $USER ./nixos && sudo chmod ugo+rw ./nixos
```


```
git clone --recurse-submodules https://github.com/maydayv7/dotfiles.git nixos
cd nixos && nixos apply
```

##### Keys
```
gpg --import ./secrets/gpg/public.gpg
gpg --import ./secrets/gpg/private.gpg
cp ./secrets/ssh ~/.ssh -r && ssh-add
```

## Notes
#### Caution
I am pretty new to Nix, and my configuration is still *WIP*, right now undergoing a transition to using Nix [Flakes](https://nixos.wiki/wiki/Flakes), an unstable feature. If you have any doubts or suggestions, feel free to open an issue

#### Branches
There are two branches, `stable` and `develop`. The `stable` branch can be used at any time, and consists of configuration that builds without failure, but the `develop` branch is a bleeding-edge testbed, and is not recommended to be used. Releases are always made from the `stable` branch after it has been battle-tested

#### Requirements
- Intel CPU + iGPU
- UEFI System (for use with GRUB EFI Bootloader)

#### System Management
##### Data Storage
User files are stored on an NTFS partition mounted to `/data`

##### Build
While rebuilding system with Flakes, make sure that any file with unstaged changes will not be included. Use `git add .` in cases where the `git` tree is dirty

##### Cache
The system build cache is publicly hosted using [Cachix](https://www.cachix.org) at [maydayv7-dotfiles](https://app.cachix.org/cache/maydayv7-dotfiles), and can be used while building the system to prevent rebuilding from scratch

##### Credentials
The `secrets` directory is a `git submodule` pointing to a private repository containing passwords and other authentication credentials. User passwords are specified using the `passwordFile` option

##### Scripts
A system management script has been included in `scripts`, invoked with the command `nixos`, which can be used to apply user and system configuration changes or perform various other useful functions

##### File System
These configuration files can be used to setup the system using either ext4 or BTRFS (with opt-in state). The opt-in state (using TMPFS for `/`) allows for a vastly improved experience, preventing any cruft to form and exerting total control over the system's state, by erasing the system at every boot, keeping only what's required/defined

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
