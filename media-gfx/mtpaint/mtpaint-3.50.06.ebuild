# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Simple GTK+2 painting program"
HOMEPAGE="https://github.com/wjaguar/mtPaint"

EGIT_COMMIT="70306581a6212b728ab35fbbbbe72702863c5acb"
SRC_URI="https://github.com/wjaguar/mtPaint/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gif jpeg nls tiff"

DEPEND="dev-libs/glib
	>=media-libs/libpng-1.2.7:0
	>=sys-devel/gettext-0.14.1
	>=sys-libs/zlib-1.2.1
	>=x11-libs/gtk+-2.6.4:2
	>=x11-libs/pango-1.8.0
	gif? ( >=media-libs/giflib-4.1.4 )
	jpeg? ( virtual/jpeg:0 )
	tiff? ( >=media-libs/tiff-3.6.1:0 )"

RDEPEND="${DEPEND}"

DOCS=("README" "NEWS")

S="${WORKDIR}/mtPaint-${EGIT_COMMIT}"

src_configure() {
	# Set Gentoo CFLAGS
	sed -i "s/-O2 \$MARCH/${CFLAGS}/g" configure || die

	econf \
			man \
			intl \
			thread \
			release
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
