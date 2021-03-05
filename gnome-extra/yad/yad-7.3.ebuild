# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit eutils xdg-utils gnome2-utils

DESCRIPTION="A tool for creating graphical dialogs from shell scripts. Fork of zenity."
HOMEPAGE="https://github.com/v1cont/yad"
SRC_URI="https://github.com/v1cont/yad/releases/download/v${PV}/${P}.tar.xz"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3
		x11-libs/libX11
		dev-libs/glib:2"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		sys-devel/gettext
		dev-util/intltool
		app-arch/xz-utils"

src_prepare() {
	# apply user patchs
	eapply_user
}

src_configure() {
	econf
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
