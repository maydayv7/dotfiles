#! /usr/bin/env nix-shell
#! nix-shell -i bash -p dosfstools ntfs3g parted util-linux zfs

# Script to automatically Create, Label, Format and Mount Partitions #

partition_disk() {
  read -rp "Enter Path to Disk: /dev/" DISK
  if [ -z "$DISK" ]
  then
    error "Path to Disk cannot be empty. If unsure, use the command 'fdisk -l'"
  fi
  echo "Creating Partitions..."
  parted /dev/"$DISK" -- mkpart ESP fat32 1MiB 1024MiB
  parted /dev/"$DISK" -- set 1 esp on
  parted /dev/"$DISK" -- name 1 ESP
  mkfs.fat -F 32 /dev/disk/by-partlabel/ESP
  parted /dev/"$DISK" -- mkpart primary 1025MiB -8GiB
  parted /dev/"$DISK" -- name 2 System
  parted /dev/"$DISK" -- mkpart primary linux-swap -8GiB 100%
  parted /dev/"$DISK" -- name 3 swap
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
  read -rp "Enter Password for Pool Encryption: " PASS
  echo "$PASS" | zpool create -f fspool -O compression=zstd -O encryption=on -O keyformat=passphrase /dev/disk/by-partlabel/System
  zfs create -p -o mountpoint=legacy -o xattr=sa -o acltype=posixacl fspool/system/root
  zfs snapshot fspool/system/root@blank
  zfs create -o mountpoint=legacy -o atime=off fspool/system/nix
  zfs create -p -o mountpoint=legacy -o xattr=sa -o acltype=posixacl -o com.sun:auto-snapshot=true fspool/data
  zfs create -o canmount=off -o refreservation=1G fspool/reserve # Use 'zfs set refreservation=none fspool/reserve' to free space
}

mount_zfs() {
  echo "Mounting 'ZFS' Volumes..."
  zpool import -f fspool
  mount -t zfs fspool/system/root /mnt
  mkdir -p /mnt/{nix,data}
  mount -t zfs fspool/system/nix /mnt/nix
  mount -t zfs fspool/data /mnt/data
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
