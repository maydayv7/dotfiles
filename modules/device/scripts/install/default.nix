{ config, lib, pkgs, ... }:
let
  cfg = config.scripts.install;

  # NixOS Install Script
  script = with pkgs; writeScriptBin "install"
  ''
    #!${pkgs.runtimeShell}
    set +x

    read -p "Select Device to Install (Vortex/Futura): " choice
      case $choice in
        1) HOST=Vortex;;
        2) HOST=Futura;;
        *) echo "error: Answer (1)Vortex or (2)Futura"; exit 125;;
      esac

    read -p "Select Filesystem to use for Disk (ext4/btrfs): " choice
      case $choice in
        1) SCHEME=ext4;;
        2) SCHEME=btrfs;;
        *) echo "error: Answer (1)ext4 or (2)btrfs"; exit 125;;
      esac

    read -p "Enter Path to Disk: /dev/" DISK
    read -p "Enter Github Authentication Token: " KEY

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
        [Yy]*) reboot;;
        *) exit;;
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

  config = lib.mkIf cfg
  {
    environment.systemPackages = [ script ];
  };
}
