# Arch Linux BTRFS Install
Enter custom values for THESE letters  
*These* and ***these*** letters are comments  

## Create live disk
Go to [this](https://www.archlinux.org/download/) website and download the latest .iso file, then either burn it to a USB using [Etcher](https://www.balena.io/etcher/) or a CD using [Brasero](https://wiki.gnome.org/Apps/Brasero). Make sure that the size of the device is at least 1 GB

## Network
*Replace* ***DEVICE*** *with the name of the device found from device list*  
`iwctl`  
`device list`  
`station DEVICE get-networks`  
`station DEVICE connect NETWORK`  
`exit`  

## Partitions
Create your partitions using a tool like [Gparted](https://gparted.org/) or [cfdisk](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjM3OO5yLnwAhUDXSsKHZi0DGcQFjABegQIAhAD&url=https%3A%2F%2Fman.archlinux.org%2Fman%2Fcfdisk.8.en&usg=AOvVaw1IUZ8UEyqlKjnpyVtymdfu). It is recommended to have an ESP or BOOT Partition, a ROOT Partition and a DATA Partition for storing files

`fdisk -l`  
*Check which partitions to install onto and note their* ***number***  
*Replace* ***X***, ***Y*** and ***Z*** *with the required partitions as 
found from the above command*

`mkfs.btrfs -f -L Root /dev/X` **- ROOT Partition**  
`mkfs.fat -F32 -n BOOT /dev/Y` **- BOOT Partition**  
`mkswap -L Swap /dev/Z` **- SWAP Partition (Optional)**  
`mount /dev/X /mnt`  
`cd /mnt`  
`btrfs subvolume create @`  
`btrfs subvolume create @home`  
`btrfs subvolume create snapshots`  
`cd`  
`umount /mnt`  
`mount -o noatime,space_cache=v2,ssd,compress=zstd,subvol=@ /dev/X /mnt`  
`mkdir /mnt/home`  
`mount -o noatime,space_cache=v2,ssd,compress=zstd,subvol=@home /dev/X/mnt/home`  
`swapon /dev/Z`

*Skip below if using a ***UEFI*** System*  
`mkdir /mnt/boot`  
`mount /dev/Y /mnt/boot`

## Install Arch
`pacstrap /mnt base linux linux-firmware nano base-devel man-db man-pages 
texinfo btrfs-progs`  
`genfstab -U /mnt >> /mnt/etc/fstab`

### Configuring Disks
`mkdir /mnt/mnt/volume`  
`nano /mnt/etc/fstab`  
*Remove subvolids from all entries, add the /mnt/volume entry. Eg:*  
```
# ROOT Subvolume
UUID=1a787b5a-c649-4c75-b8bc-b0ac970a1b6d       /               btrfs           rw,noatime,compress=zstd:3,ssd,space_cache=v2,autodefrag,subvol=@      0 0

# HOME Subvolume
UUID=1a787b5a-c649-4c75-b8bc-b0ac970a1b6d       /home           btrfs           rw,noatime,compress=zstd:3,ssd,space_cache=v2,autodefrag,subvol=@home  0 0

# BTRFS Partition
UUID=1a787b5a-c649-4c75-b8bc-b0ac970a1b6d       /mnt/volume     btrfs           rw,noatime,discard,autodefrag,space_cache=v2,subvol=/                  0 0

# SWAP Partition
UUID=e82defeb-409d-449f-bd51-cdd87bd2af02       none            swap            defaults                                                               0 0
```
*To get the UUID of a partition, use the `blkid` command*

## General Settings
`arch-chroot /mnt`

`timedatectl set-timezone CONTINENT/CITY`  
`nano /etc/locale.gen`  
***Uncomment*** *the required locale*  
`locale-gen`  
`nano /etc/locale.conf`  
*Add:* 
*LANG=**ab_CD**.UTF-8*

*Replace* ***HOSTNAME*** *with the desired name for your computer*  
`echo HOSTNAME > /etc/hostname`  
`touch /etc/hosts`  
`nano /etc/hosts`  
*Add:*  
```
127.0.0.1       localhost
::1             localhost
127.0.1.1       HOSTNAME
```

*Replace* ***USER*** *with the desired username*  
`passwd`  
`useradd -m USER`  
`passwd USER`  
`export EDITOR=nano`  
`visudo`  
*Add:*  
*USER* ***ALL=(ALL) ALL***  

## Bootloader
`pacman -S grub`

#### For BIOS Systems
`grub-install /dev/X`  
`grub-mkconfig -o /boot/grub/grub.cfg`

#### For UEFI Systems
`pacman -S efibootmgr`  
`mkdir /boot/efi`  
`mount /dev/Y /boot/efi`  
`grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi`  
`grub-mkconfig -o /boot/grub/grub.cfg`

## Desktop Environment
### Gnome
`pacman -S xorg gnome networkmanager`  
`systemctl enable gdm`

### XFCE
`pacman -S xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings networkmanager`  
`systemctl enable lightdm`

### KDE
`pacman -S xorg plasma plasma-wayland-session`  
`systemctl enable sddm`

## After Install
### Essential Utilites
`pacman -S bluez bluez-utils cups git ntfs-3g intel-ucode system-config-printer`  
`systemctl enable bluetooth`  
`systemctl enable cups`  
`systemctl enable NetworkManager`

### Zram (Optional)
`nano /etc/systemd/system/zram.service`  
*Add the following by changing the size according to your RAM:*  
```
[Unit] 
Description=zRam block devices swapping 
 
[Service] 
Type=oneshot 
ExecStart=/usr/bin/bash -c "modprobe zram && echo lz4 > /sys/block/zram0/comp_algorithm && echo 6G > /sys/block/zram0/disksize && mkswap --label zram0 /dev/zram0 && swapon --priority 100 /dev/zram0" 
ExecStop=/usr/bin/bash -c "swapoff /dev/zram0 && rmmod zram" 
RemainAfterExit=yes 
 
[Install] 
WantedBy=multi-user.target
```
`systemctl enable zram`

### We're Done! :)
`exit`  
`reboot`