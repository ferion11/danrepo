# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KLOGG_PN="${PN/-bin/}"

inherit desktop xdg-utils unpacker

DESCRIPTION="Fast log explorer for big files"
HOMEPAGE="https://klogg.filimonov.dev"
SRC_URI="https://github.com/variar/klogg/releases/download/v${PV}/klogg-${PV}.0.808-Linux.deb"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-qt/qtcore-5.9
	>=dev-qt/qtgui-5.9
	>=dev-qt/qtwidgets-5.9
	>=dev-qt/qtconcurrent-5.9
	>=dev-qt/qtnetwork-5.9
	>=dev-qt/qtxml-5.9
	>=dev-qt/qttest-5.9
	net-misc/curl
"

QA_PREBUILT="*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	mv "${S}/usr/lib" "${S}/usr/lib64" || die "Install change lib to lib64 failed!"
	cp -r "${S}/usr" "${D}/" || die "Install failed!"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
