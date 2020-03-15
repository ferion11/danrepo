[![Gentoo Badge](https://www.gentoo.org/assets/img/badges/gentoo-badge.png)](https://www.gentoo.org)

# danrepo

>  Gentoo Linux - Personal Portage Overlay

## How to use this overlay with local overlays:
[Local overlays](https://wiki.gentoo.org/wiki//etc/portage/repos.conf) should be managed via `/etc/portage/repos.conf/`.
To enable this overlay make sure you are using a recent Portage version (at least `2.2.14`), and create a `/etc/portage/repos.conf/danrepo.conf` file containing precisely:

```
[danrepo]
location = /var/db/repos/danrepo
sync-type = git
sync-uri = https://github.com/ferion11/danrepo.git
priority=9999
```

Afterwards, simply run `emerge --sync`, and Portage should seamlessly make all our ebuilds available.

###  Include:
* media-gfx/mtpaint - Simple GTK+2 painting program.
* sys-fs/exfat-linux - exFAT filesystem module for Linux kernel (new and updated).
* sys-fs/exfat-nofuse - Non-fuse kernel driver for exFat and VFat file systems (old, but fixed).
* x11-misc/gromit-mpx - Gromit-MPX is a multi-pointer GTK3 port of the original Gromit.
* media-fonts/ttf-wps-fonts - These are the symbol fonts required by app-office/wps-office.
* gnome-extra/yad - Yet Another Dialog. A tool for creating graphical dialogs from shell scripts. Fork of zenity.
* net-misc/zsync2 - zsync2 is one improved version of zsync.
* sys-auth/polkit - Polkit with duktape flag to replace spidermonkey.
* media-gfx/mirage - A fast and simple image viewer based on python and GTK+ (python3.6 version).
* media-gfx/fragment - Fragment is an exceptionally powerful, versatile and functional image viewer.
* and can include some more updated version of some portage ebuilds.

###  Installation
After performing those steps, the following should work (or any other package from this overlay):

```
sudo emerge -av sys-fs/exfat-linux
```
