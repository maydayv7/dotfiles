# Useful Commands

#### GRUB

_The update-grub script:_  
_Add the following in_ **/usr/sbin/update-grub**

**_#!/bin/sh_**  
**_set -e_**  
**_exec grub-mkconfig -o /boot/grub/grub.cfg_**

_Then execute:_  
`sudo chown root:root /usr/sbin/update-grub`  
`sudo chmod 755 /usr/sbin/update-grub`

#### Virtualization

`sudo usermod -a -G libvirt $(whoami)`  
`newgrp libvirt`  
`sudo usermod -a -G kvm $(whoami)`

#### Fonts

`sudo ln -s /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/`  
`sudo ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/`  
`sudo fc-cache -fv`

#### Theming

_To set QT theme in GTK+ based DEs using qt5ct, add the following in /etc/environment:_  
`QT_QPA_PLATFORMTHEME=qt5ct`

_To make apps running as root in **OpenSUSE** use the right theme:_  
`sudo ln -s /home/USER/.config/kdeglobals /root/.config/kdeglobals`  
`sudo ln -s /home/USER/.config/gtk-4.0 /root/.config/gtk-4.0`

#### Filesystem

_Fix NTFS Disk after a faulty Windows shutdown:_  
`sudo ntfsfix /dev/X`

_Create symlinks for home directories (Useful for multiboot)_  
`ln -s /PATH/HOME_DIR ~/home/USER/HOME_DIR`

_If a home directory got deleted or if you want a custom home directory, modify this file_  
`nano ~/.config/user-dirs.dirs`

_How I mount my data partition_  
`sudo mkdir /data`  
`sudo chmod ugo+rw /data`

```
# DATA Partition
UUID=partuuid	/data	ntfs	rw,defaults,x-gvfs-show	0 0
```

#### Miscellaneous

_To clear configuration files of deleted apps in **Debian**:_  
`sudo dpkg --purge dpkg --get-selections | grep deinstall | cut -f1`
