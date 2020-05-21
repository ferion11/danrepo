# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3 eutils autotools flag-o-matic

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="http://desmume.org/"
EGIT_REPO_URI="https://github.com/TASVideos/desmume.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-debug glade +glx +gtk hud openal osmesa wifi"

DEPEND="virtual/opengl
	sys-libs/zlib
	dev-libs/zziplib
	media-libs/libsdl[joystick]
	x11-libs/agg
	virtual/libintl
	sys-devel/gettext
	openal? ( media-libs/openal )
	gtk? ( x11-libs/gtk+:2 )
	glade? ( gnome-base/libglade )
	osmesa? ( media-libs/mesa[osmesa] )
	wifi? ( net-libs/libpcap )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/desmume/src/frontend/posix"

src_prepare() {
	use wifi && \
		eerror "wifi support is broken and may not work"

	if ! use gtk && use glade; then
		einfo "glade support was requested but not gtk"
		einfo "glade(libglade) depends on gtk"
		einfo "it may be useful to enable gtk support after all"
	fi

	eautoreconf

	append-cppflags -std=gnu++0x

	default
}

src_configure() {
	econf --datadir=/usr/share \
		$(use_enable openal) \
		$(use_enable glx) \
		$(use_enable osmesa) \
		$(use_enable hud) \
		$(use_enable wifi) \
		$(use_enable debug) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	if ! use gtk; then
		[ -f "${D}/bin/desmume" ] && rm "${D}/bin/desmume"
	fi
	if ! use glade; then
		[ -f "${D}/bin/desmume-glade" ] && rm "${D}/bin/desmume-glade"
	fi
}
