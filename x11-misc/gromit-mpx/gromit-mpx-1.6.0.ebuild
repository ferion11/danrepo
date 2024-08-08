# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Gromit-MPX is a multi-pointer GTK3 port of the original Gromit"
HOMEPAGE="https://github.com/bk138/gromit-mpx"
SRC_URI="https://github.com/bk138/gromit-mpx/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/libayatana-appindicator
	x11-libs/libX11
	>=x11-apps/xinput-1.3
"
DEPEND="${RDEPEND}"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
