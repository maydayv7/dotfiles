{ lib, pkgs, files, ... }:
with pkgs;
with files;
lib.recursiveUpdate {
  meta.description = "NixOS Install Script";
  buildInputs = [ coreutils git gnupg ];
} (writeShellScriptBin "install" ''
  #!${runtimeShell}
  # This script must be executed as 'root'
  set +x
  ${commands}

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

  read -p "Enter Path to GPG Keys: " KEY
  getKeys $KEY
  echo "Importing Keys..."
  sudo mkdir -p ${gpg}
  for key in $KEY/*.gpg
  do
    sudo gpg --homedir ${gpg} --import $key
  done
  printf "\n"

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

  echo "Mounting $SCHEME Partitions..."
  if [ "$SCHEME" == "ext4" ]
  then
    mkfs.ext4 /dev/disk/by-partlabel/System
    mount /dev/disk/by-partlabel/System /mnt
  else
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
  fi
  printf "\n"

  echo "Mounting Other Partitions..."
  mkdir -p /mnt/boot
  mount /dev/disk/by-partlabel/ESP /mnt/boot
  swapon /dev/disk/by-partlabel/swap
  printf "\n"

  echo "Installing System..."
  nixos-install --no-root-passwd --root /mnt --flake gitlab:maydayv7/dotfiles#$HOST --impure
  printf "\n"

  read -p "Do you want to reboot the system? (Y/N): " choice
    case $choice in
      [Yy]*) reboot;;
      *) exit;;
    esac
'')
