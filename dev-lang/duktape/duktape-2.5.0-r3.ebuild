# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Embeddable Javascript engine"
HOMEPAGE="https://duktape.org"
SRC_URI="https://duktape.org/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+cmdline -debug -libm"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	cp Makefile.sharedlibrary Makefile || die "failed to copy makefile"

	# Set install path
	sed -i "s#INSTALL_PREFIX = /usr/local#INSTALL_PREFIX = ${D::-1}/usr#" \
			Makefile || die "failed to set install path"

	# Edit pkgconfig
	sed "s#VERSION#${PV}#" "${FILESDIR}/${PN}.pc" > "${S}/${PN}.pc" || die
	sed -i "s#LIBDIR#$(get_libdir)#" "${S}/${PN}.pc" || die

	# Set lib folder
	sed -i "s#(INSTALL_PREFIX)/lib#(INSTALL_PREFIX)/$(get_libdir)#" \
		Makefile || die

	# Remove debug flag
	sed -i 's/ -g / /g' Makefile || die

	if use debug; then
		# Add debug -g flag
		sed -i 's/-Wextra/-Wextra -g/g' Makefile || die
		sed -i 's/-Wall/-Wall -g/g' Makefile.cmdline || die
	fi

	# Set Gentoo CFLAGS
	sed -i "s/-Os/${CFLAGS}/g" Makefile || die
	sed -i "s/-Os/${CFLAGS}/g" Makefile.cmdline || die

	if use libm; then
		# Add libm.so ref.
		sed -i 's/duktape.c/duktape.c -lm/g' Makefile || die
	fi

	# bugfix wrong eapi7 INSTALL_PREFIX at 2020/04/05
	sed -i "s/\/imag\//\/image\//g" Makefile || die

	eapply_user
}

src_compile() {
	emake || die

	if use cmdline; then
		emake -f Makefile.cmdline || die
	fi
}

src_install() {
	dodir /usr/$(get_libdir)
	dodir /usr/include
	emake install

	insinto /usr/$(get_libdir)/pkgconfig/
	doins "${S}/${PN}.pc"

	if use cmdline; then
		exeinto /usr/bin
		doexe duk
	fi
}
