# Useful Commands

#### GRUB
*The update-grub script:*  
*Add the following in* **/usr/sbin/update-grub**  

***#!/bin/sh***   
***set -e***  
***exec grub-mkconfig -o /boot/grub/grub.cfg***  

*Then execute:*  
`sudo chown root:root /usr/sbin/update-grub`  
`sudo chmod 755 /usr/sbin/update-grub`  

#### Virtualization
`sudo usermod -a -G libvirt $(whoami)`  
`newgrp libvirt`  
`sudo usermod -a -G kvm $(whoami)`  

#### Fonts
`sudo ln -s  /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/`  
`sudo ln -s  /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/`  
`sudo fc-cache -fv`

#### Theming
*To set QT theme in GTK+ based DEs using qt5ct, add the following in /etc/environment:*  
`QT_QPA_PLATFORMTHEME=qt5ct`  

*To make apps running as root in **OpenSUSE** use the right theme:*  
`sudo ln -s /home/USER/.config/kdeglobals /root/.config/kdeglobals`  
`sudo ln -s /home/USER/.config/gtk-4.0  /root/.config/gtk-4.0`

#### Filesystem

*Fix NTFS Disk after a faulty Windows shutdown:*  
`sudo ntfsfix /dev/X`  

*Create symlinks for home directories (Useful for multiboot)*  
`ln -s /PATH/HOME_DIR ~/home/USER/HOME_DIR`  

*If a home directory got deleted or if you want a custom home directory, modify this file*  
`nano ~/.config/user-dirs.dirs`

*How I mount my data partition*  
`sudo mkdir /data`  
`sudo chmod ugo+rw /data`
```
# DATA Partition
UUID=partuuid	/data	ntfs	rw,defaults,x-gvfs-show	0 0
```

#### Miscellaneous
*To clear configuration files of deleted apps in **Debian**:*  
`sudo dpkg --purge dpkg --get-selections | grep deinstall | cut -f1`  