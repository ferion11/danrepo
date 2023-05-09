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
* x11-misc/gromit-mpx - Gromit-MPX is a multi-pointer GTK3 port of the original Gromit.
* gnome-extra/yad - Yet Another Dialog. A tool for creating graphical dialogs from shell scripts. Fork of zenity.
* media-gfx/mirage - A fast and simple image viewer based on python and GTK+ (python3 version).
* www-client/brave-bin - Brave Web Browser binary.
* media-fonts/ttf-wps-fonts - These are the symbol fonts required by app-office/wps-office.
* media-fonts/catamaran - Catamaran is a 9 weight Tamil type-family. [See here](https://fonts.google.com/specimen/Catamaran)
* media-fonts/montserrat - Typeface inspired in the city of Montserrat in Buenos Aires. [See here](https://fonts.google.com/specimen/Montserrat)
* media-fonts/yrsa - Yrsa is Latin-only type family by Rosetta, intended for continuous reading. [See here](https://fonts.google.com/specimen/Yrsa)
* media-fonts/lato - Lato is a sanserif type­face family. [See here](https://fonts.google.com/specimen/Lato)
* media-fonts/zilla-slab - Mozilla's Zilla Slab Type Family. [See here](https://fonts.google.com/specimen/Zilla+Slab)
* and can include some more updated version of some portage ebuilds.

###  Installation
After performing those steps, the following should work (or any other package from this overlay):

```
sudo emerge -av media-fonts/yrsa
```

###  Issues
Any issue, like bugs, need more flag, need new ebuild, update some old ebuild, any information you want, or anything else, you can use:
[danrepo Issues](https://github.com/ferion11/danrepo/issues)
