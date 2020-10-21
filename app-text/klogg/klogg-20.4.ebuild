# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake flag-o-matic

DESCRIPTION="Fast log explorer for big files"
HOMEPAGE="https://klogg.filimonov.dev"
SRC_URI="https://github.com/variar/klogg/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
DEPEND="${RDEPEND}"

src_compile() {
	mkdir build
	cd build
	cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
	cmake --build .
}

pkg_postinst() {
	xdg_desktop_database_update
}
pkg_postrm() {
	xdg_desktop_database_update
}
