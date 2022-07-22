
Debian
====================
This directory contains files used to package kawkawd/kawkaw-qt
for Debian-based Linux systems. If you compile kawkawd/kawkaw-qt yourself, there are some useful files here.

## kawkaw: URI support ##


kawkaw-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install kawkaw-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your kawkaw-qt binary to `/usr/bin`
and the `../../share/pixmaps/kawkaw128.png` to `/usr/share/pixmaps`

kawkaw-qt.protocol (KDE)

