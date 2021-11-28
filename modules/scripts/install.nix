{ config, lib, pkgs, ... }:
let
  enable = config.scripts.install;

  # NixOS Install Script
  script = with pkgs; writeScriptBin "install"
  ''
    #!${pkgs.runtimeShell}
    set +x
    error()
    {
      echo -e "\033[0;31merror:\033[0m $1"
      exit 125
    }

    read -p "Select Device to Install (Vortex/Futura): " choice
      case $choice in
        1) HOST=Vortex;;
        2) HOST=Futura;;
        *) error "Choose (1)Vortex or (2)Futura";;
      esac

    read -p "Select Filesystem to use for Disk (ext4/btrfs): " choice
      case $choice in
        1) SCHEME=ext4;;
        2) SCHEME=btrfs;;
        *) error "Choose (1)ext4 or (2)btrfs";;
      esac

    read -p "Enter Path to Disk: /dev/" DISK
    if [ -z "$DISK" ]
    then
      error "Path to Disk cannot be empty. If unsure, use the command 'fdisk -l'"
    fi

    read -p "Enter Path to SSH Keys: " KEY
    if [ -z "$KEY" ]
    then
      error "Path to SSH Keys cannot be empty"
    fi

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

    if [ "$SCHEME" == "ext4" ]
    then
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

    echo "Importing Keys..."
    cp -r $KEY/. /etc/ssh
    chmod 400 /etc/ssh/ssh_key
    ssh-add /etc/ssh/ssh_key
    printf "\n"

    echo "Installing System..."
    nixos-install --no-root-passwd --root /mnt --flake github:maydayv7/dotfiles#$HOST
    cp -r $KEY/. /mnt/etc/ssh
    chmod 400 /mnt/etc/ssh/ssh_key
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

  config = lib.mkIf enable
  {
    environment.systemPackages = [ script ];
  };
}
