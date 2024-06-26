# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 xdg-utils

DESCRIPTION="A fast and simple image viewer based on python and GTK+"
HOMEPAGE="http://mirageiv.berlios.de/"
SRC_URI="
	mirror://sourceforge/mirageiv/${P}.tar.bz2
	https://github.com/ferion11/danrepo/releases/download/mirage_patchs/mirage-0.9.5.2-py3-gtk3.patch.gz
"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/gtk+:3
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	!media-plugins/banshee-mirage"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.3-prevmouse-not-defined-with-click.patch
	"${FILESDIR}"/${PN}-0.9.5.2-glib241-init-workaround.patch
	"${FILESDIR}"/${PN}-0.9.3-stop_cleaning_up.patch
	"${WORKDIR}"/${PN}-0.9.5.2-py3-gtk3.patch
)

src_install() {
	distutils-r1_src_install
	local XDOCS="COPYING CHANGELOG README TODO TRANSLATORS"
	local x
	for x in ${XDOCS}; do
		rm -f "${D}"/usr/share/mirage/${x}
	done
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
