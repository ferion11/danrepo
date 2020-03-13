# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit linux-mod

MY_PV=$(ver_cut 1-2)
BUILD=$(ver_cut 3)

DESCRIPTION="Open Sound System - drivers"
HOMEPAGE="http://developer.opensound.com/"
SRC_URI="https://www.deb-multimedia.org/pool/main/o/oss4-dmo/oss4-dkms_${MY_PV}-build${BUILD}-dmo3_amd64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	mkdir "${S}"
	cd "${S}"
	tar xf "${WORKDIR}"/data.tar.xz || die
}

src_prepare() {
	sed -e "s/-isystem \$(MULTIARCH_PATH)//" \
		-e "/^MULTIARCH_PATH/d" \
		-i usr/src/oss4-${MY_PV}-build${BUILD}/{core,drivers}/Makefile || die

	eapply_user
}

src_configure() {
	set_arch_to_kernel
}

src_compile() {
	cd "usr/src/oss4-${MY_PV}-build${BUILD}/core"
	cp /usr/include/linux/limits.h ./
	# Maybe need 'sed' to replace "EXTRA_CFLAGS" with "ccflags-y" on Makefile
	emake -C "/lib/modules/${KV_FULL}/build" M="$(pwd)" modules

	cd "../"
	emake -C drivers osscore_symbols.inc

	cd "drivers"
	rm Module.symvers
	cp ../core/Module.symvers ./
	sed -i "/^EXTRA_CFLAGS=.*/i KBUILD_EXTRA_SYMBOLS=${PWD}/Module.symvers" Makefile
	emake -C "/lib/modules/${KV_FULL}/build" M="$(pwd)" modules
}

src_install() {
	cd usr/src/oss4-${MY_PV}-build${BUILD}
	#insinto /lib/modules/${KV_FULL}/kernel/sound/core
	insinto /lib/modules/${KV_FULL}/kernel/sound/oss
	doins core/osscore.${KV_OBJ}

	#insinto /lib/modules/${KV_FULL}/kernel/sound/pci
	doins drivers/*.${KV_OBJ}
}

pkg_postinst() {
	UPDATE_MODULEDB=true
	linux-mod_pkg_postinst

	elog "To get sound devices, you need to run"
	elog "	# ossdetect -d"
	elog "and"
	elog "	# ossdevlinks"
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
