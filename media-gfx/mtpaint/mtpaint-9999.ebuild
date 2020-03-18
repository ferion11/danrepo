# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 xdg-utils

DESCRIPTION="Simple GTK+2 painting program"
HOMEPAGE="https://github.com/wjaguar/mtPaint"

EGIT_REPO_URI="https://github.com/wjaguar/mtPaint.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gif jpeg nls threads tiff"

DEPEND=">=dev-libs/glib-2.6.4:2
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

usev_no() {
	usex "$1" "${2:-$1}" "no${2:-$1}"
}

src_configure() {
	# use debug to allow custom cflags
	econf \
		debug \
		man \
		$(usev_no gif "GIF") \
		$(usev_no jpeg) \
		$(usev_no threads) \
		$(usev_no nls "intl") \
		$(usev_no tiff)

	# append custom cflags to cflag variable
	echo "CFLAG += ${CFLAGS}" >> _conf.txt || die "Failed to add CFLAGS."
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
