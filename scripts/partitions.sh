# Script to automatically Create, Label, Format and Mount Partitions

partition_disk() {
  read -p "Enter Path to Disk: /dev/" DISK
  if [ -z "$DISK" ]
  then
    error "Path to Disk cannot be empty. If unsure, use the command 'fdisk -l'"
  fi
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

create_ext4() {
  echo "Creating 'EXT4' Partition..."
  mkfs.ext4 /dev/disk/by-partlabel/System
}

mount_ext4() {
  echo "Mounting 'EXT4' Partition..."
  mount /dev/disk/by-partlabel/System /mnt
}

create_zfs() {
  echo "Creating 'ZFS' Volumes..."
  zpool create -f fspool -o compression=zstd /dev/disk/by-partlabel/System
  zfs create -p -o mountpoint=legacy -o xattr=sa -o acltype=posixacl fspool/system/root
  zfs snapshot fspool/system/root@blank
  zfs create -o mountpoint=legacy -o atime=off fspool/system/nix
  zfs create -p -o mountpoint=legacy fspool/data/persist
  zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true fspool/data/home
  zfs create -o canmount=off -o refreservation=1G fspool/blank
}

mount_zfs() {
  echo "Mounting 'ZFS' Volumes..."
  zpool export -a
  zpool import -f fspool
  mount -t zfs fspool/system/root /mnt
  mkdir -p /mnt/{nix,persist,home}
  mount -t zfs fspool/system/nix /mnt/nix
  mount -t zfs fspool/data/persist /mnt/persist
  mount -t zfs fspool/data/home /mnt/home
}

mount_other() {
  echo "Mounting Other Partitions..."
  mkdir -p /mnt/boot
  mount -t vfat /dev/disk/by-partlabel/ESP /mnt/boot
  swapoff --all
  swapon /dev/disk/by-partlabel/swap
}

unmount_all () {
  echo "Unmounting All Partitions..."
  umount -l /mnt
  zpool export fspool
}
