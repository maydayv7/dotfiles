{ config, lib, pkgs, ... }:
let
  cfg = config.scripts.install;

  # NixOS Install Script
  script = with pkgs; writeScriptBin "install"
  ''
    #!${pkgs.runtimeShell}
    set +x

    read -p "Enter name of Device to install: " HOST
    read -p "Enter path to disk: /dev/" DISK
    read -p "Enter filesystem to use for disk: " SCHEME
    read -p "Enter Github authentication token: " KEY

    echo "Creating Partitions..."
    parted /dev/$DISK -- mkpart ESP fat32 1MiB 1024MiB
    parted /dev/$DISK -- set 1 esp on
    mkfs.fat -F 32 /dev/disk/by-partlabel/ESP
    parted /dev/$DISK -- mkpart primary 1024MiB -8GiB
    parted /dev/$DISK -- name 2 System
    parted /dev/$DISK -- mkpart primary linux-swap -8GiB 100%
    parted /dev/$DISK -- name 3 swap
    mkswap /dev/disk/by-partlabel/swap
    mkdir -p /mnt
    printf "\n"

    if [ "$SCHEME" == "ext4" ]; then
        echo "Mounting EXT4 Partitions..."
        mkfs.ext4 /dev/disk/by-partlabel/System
        mount /dev/disk/by-partlabel/System /mnt
        printf "\n"
      else
        echo "Mounting BTRFS Partitions..."
        mkfs.btrfs -f /dev/disk/by-partlabel/System
        mount /dev/disk/by-partlabel/System /mnt
        btrfs subvolume create /mnt/home
        btrfs subvolume create /mnt/nix
        btrfs subvolume create /mnt/persist
        umount /mnt
        mount -t tmpfs none /mnt
        mkdir /mnt/{home,nix,persist}
        mount -o subvol=home,compress=zstd,autodefrag,noatime /dev/disk/by-partlabel/System /mnt/home
        mount -o subvol=nix,compress=zstd,autodefrag,noatime /dev/disk/by-partlabel/System /mnt/nix
        mount -o subvol=persist,compress=zstd,autodefrag,noatime /dev/disk/by-partlabel/System /mnt/persist
        printf "\n"
    fi

    echo "Mounting Other Partitions..."
    mkdir -p /mnt/boot
    mount /dev/disk/by-partlabel/ESP /mnt/boot
    swapon /dev/disk/by-partlabel/swap
    printf "\n"

    echo "Installing System..."
    nixos-install --no-root-passwd --flake github:maydayv7/dotfiles#$HOST --option access-tokens= github.com=$KEY
    printf "\n"

    read -p "Do you want to reboot the system? (Y/N): " choice
      case $choice in
        [Yy]* ) reboot;;
        [Nn]* ) exit;;
        * ) echo "Please answer (Y)es or (N)o.";;
      esac
  '';
in rec
{
  options.scripts.install = lib.mkOption
  {
    description = "Script for Installing NixOS";
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf (cfg == true)
  {
    environment.systemPackages = [ script ]; 
  };
}
