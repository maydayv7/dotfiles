{ lib, pkgs, files, ... }:
with pkgs;
with files;
lib.recursiveUpdate {
  meta.description = "NixOS Install Script";
  buildInputs = [ coreutils git gnupg gparted parted zfs ];
} (writeShellScriptBin "nixos-install-device" ''
  #!${runtimeShell}
  set +x
  ${scripts.commands}

  if [ "$EUID" -ne 0 ]
  then
    error "This Script must be Executed as 'root'"
  fi

  read -p "Enter name of Device to Install: " HOST
  read -p "Select Filesystem to use for Disk (simple/advanced): " choice
    case $choice in
      1|[Ss]*) SCHEME=ext4;;
      2|[Aa]*) SCHEME=zfs;;
      *) error "Choose (1)simple or (2)advanced";;
    esac

  read -p "Enter Path to Disk: /dev/" DISK
  if [ -z "$DISK" ]
  then
    error "Path to Disk cannot be empty. If unsure, use the command 'fdisk -l'"
  fi

  read -p "Do you want to Automatically Create the Partitions? (Y/N): " choice
    case $choice in
      [Yy]*) partition;;
      *) echo "You must Create, Format and Label the Partitions on your own"; gparted;;
    esac

  partition() {
    echo "Creating Partitions..."
    parted /dev/$DISK -- mkpart ESP fat32 1MiB 1024MiB
    parted /dev/$DISK -- set 1 esp on
    mkfs.fat -F 32 /dev/disk/by-partlabel/ESP
    parted /dev/$DISK -- mkpart primary 1025MiB -8GiB
    parted /dev/$DISK -- name 2 System
    parted /dev/$DISK -- mkpart primary linux-swap -8GiB 100%
    parted /dev/$DISK -- name 3 swap
    mkswap /dev/disk/by-partlabel/swap
    mkdir -p /mnt
  }
  newline

  echo "Mounting '$SCHEME' Partitions..."
  if [ "$SCHEME" == "ext4" ]
  then
    mkfs.ext4 /dev/disk/by-partlabel/System
    mount /dev/disk/by-partlabel/System /mnt
  else
    zpool create -f fspool /dev/disk/by-partlabel/System
    zfs set compression=on fspool
    zfs create -p -o mountpoint=legacy fspool/system/root
    zfs set xattr=sa fspool/system/root
    zfs set acltype=posixacl fspool/system/root
    zfs snapshot fspool/system/root@blank

    mount -t zfs fspool/system/root /mnt
    mkdir -p /mnt/{nix,persist,home}

    zfs create -p -o mountpoint=legacy fspool/system/nix
    zfs set atime=off fspool/system/nix
    mount -t zfs fspool/system/nix /mnt/nix

    zfs create -p -o mountpoint=legacy fspool/data/home
    mount -t zfs fspool/data/home /mnt/home
    zfs set com.sun:auto-snapshot=true fspool/data/home

    zfs create -p -o mountpoint=legacy fspool/data/persist
    mount -t zfs fspool/data/persist /mnt/persist
    zfs set com.sun:auto-snapshot=true fspool/data/persist
  fi
  newline

  echo "Mounting Other Partitions..."
  mkdir -p /mnt/boot
  mount -t vfat /dev/disk/by-partlabel/ESP /mnt/boot
  swapon /dev/disk/by-partlabel/swap
  newline

  read -p "Enter Path to Repository (path/URL): " URL
  if [ -z "$URL" ]
  then
    URL="gitlab:maydayv7/dotfiles"
  fi
  echo "Installing System from '$URL'..."
  nixos-install --no-root-passwd --root /mnt --flake $URL#$HOST --impure
  newline

  read -p "Do you want to Reboot the System? (Y/N): " choice
    case $choice in
      [Yy]*) reboot;;
      *) exit;;
    esac
'')
