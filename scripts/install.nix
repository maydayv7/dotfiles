{
  lib,
  pkgs,
  files,
  ...
}:
with files.path; let
  inherit (lib) licenses recursiveUpdate;

  # File System Operations
  partitions = ''
    partition_disk() {
      read -rp "Enter Path to Disk: /dev/" DISK
      if [ -z "$DISK" ]
      then
        error "Path to Disk cannot be empty. If unsure, use the command 'fdisk -l'"
      fi

      echo "Deleting Partitions..."
      dd if=/dev/zero of=/dev/"$DISK" bs=512 count=1
      if [[ "$DISK" == nvme* ]]
      then
        parted /dev/"$DISK" --script mklabel gpt
      else
        parted /dev/"$DISK" --script mklabel msdos
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

      # Use 'zfs set refreservation=none fspool/reserve' to free space
      zfs create -o canmount=off -o refreservation=1G fspool/reserve
    }

    mount_zfs() {
      echo "Mounting 'ZFS' Volumes..."
      zpool import -f fspool
      mount -t zfs fspool/system/root /mnt
      mkdir -p /mnt/{nix,data}
      mount -t zfs fspool/system/nix /mnt/nix
      mkdir -p /mnt${persist}
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
  '';
in
  recursiveUpdate {
    meta = {
      mainProgram = "os-install";
      description = "System Install Script";
      homepage = repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  } (pkgs.writeShellApplication {
    name = "os-install";
    runtimeInputs = with pkgs; [
      coreutils
      dosfstools
      git
      gparted
      nixFlakes
      ntfs3g
      parted
      util-linux
      zfs
    ];

    text = ''
      set +eu
      ${files.scripts.commands}
      ${partitions}

      internet
      if [ "$EUID" -ne 0 ]
      then
        error "This Command must be Executed as 'root'"
      fi

      warn "Disk will be Completely Wiped for Automatic Partitioning"
      read -rp "Do you want to Automatically Create the Partitions? (Y/N): " choice
        case $choice in
          [Yy]*) partition_disk;;
          *) warn "You must Create, Format and Label the Partitions on your own"; gparted &> /dev/null;;
        esac
      newline
      read -rp "Select Filesystem to use for Disk (simple/advanced): " choice
        case $choice in
          1|[Ss]*)
            read -rp "Do you want to Create and Format the EXT4 Partitions? (Y/N): " choice
              case $choice in
                [Yy]*) create_ext4; mount_ext4;;
                *) warn "Assuming that Required EXT4 Partition has already been Created"; mount_ext4;;
              esac
          ;;
          2|[Aa]*)
            read -rp "Do you want to Create the ZFS Pool and Datasets? (Y/N): " choice
              case $choice in
                [Yy]*) create_zfs; mount_zfs;;
                *) warn "Assuming that Required ZFS Pool and Datasets have already been Created"; mount_zfs;;
              esac
          ;;
          *) error "Choose (1)simple or (2)advanced";;
        esac
      newline

      mount_other
      systemd-machine-id-setup --root=/mnt
      newline

      read -rp "Enter Name of Device to Install: " HOST
      read -rp "Enter Path to Repository (path/URL): " URL
      if [ -z "$URL" ]
      then
        URL=${flake}
      fi
      echo "Installing System from '$URL'..."
      until nixos-install --no-root-passwd --root /mnt --flake "$URL"#"$HOST"
      do
        newline
        info "Couldn't finish installation. Trying again..."
      done
      newline

      unmount_all
      newline

      info "Run 'nixos setup' after rebooting to finish the install"
      info "Select the (Recovery) boot menu option and run the above script as the 'recovery' user"
      restart
    '';
  })
