# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="PINCE is a front-end/reverse engineering tool for GDB."
HOMEPAGE="https://github.com/korcankaraokcu/PINCE"
EGIT_REPO_URI="https://github.com/korcankaraokcu/PINCE.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-admin/sudo
	dev-lang/python
	dev-libs/distorm3
	dev-python/pexpect
	dev-python/psutil
	dev-python/pygdbmi
	dev-python/PyQt5
	dev-util/scanmem
	sys-devel/gdb
"
DEPEND="${RDEPEND}"

src_configure() {
	# Compile static libscanmem
	mkdir -p libPINCE/libscanmem
	cd scanmem
	sh autogen.sh
	./configure --prefix="/usr"
}

src_compile() {
	cd scanmem
	make libscanmem.la
	cp --preserve .libs/libscanmem.so ../libPINCE/libscanmem/libscanmem.so
	cp --preserve gui/scanmem.py ../libPINCE/libscanmem
	cp --preserve gui/misc.py ../libPINCE/libscanmem
	cd ..

	sed -i 's/import misc/from \. import misc/g' libPINCE/libscanmem/scanmem.py
	sed -i 's/\.\/gdb_pince\/gdb.*\/bin\/gdb/\/usr\/bin\/gdb/g' libPINCE/type_defs.py

	#sed -i 's/\ssudo python3 PINCE.py/cd \/usr\/share\/PINCE \&\& sudo python3 PINCE.py/' PINCE.sh
	#sed -i 's/\ssudo -E python3 PINCE.py/cd \/usr\/share\/PINCE \&\& sudo -E python3 PINCE.py/' PINCE.sh
	#sed -i 's/OS=.*/OS="Gentoo"/' PINCE.sh
}

src_install() {
	mkdir -p "${D}/usr/bin"
	cp "${FILESDIR}/pince" "${D}/usr/bin"
	chmod +x "${D}/usr/bin/pince"

	mkdir -p "${D}/usr/share/PINCE"
	cp PINCE.py "${D}/usr/share/PINCE"
	cp COPYING "${D}/usr/share/PINCE"
	cp AUTHORS "${D}/usr/share/PINCE"
	cp THANKS "${D}/usr/share/PINCE"

	cp -r GUI "${D}/usr/share/PINCE"
	cp -r libPINCE "${D}/usr/share/PINCE"
	cp -r media "${D}/usr/share/PINCE"
}
