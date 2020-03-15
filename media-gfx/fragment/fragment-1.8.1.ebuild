# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker xdg

DESCRIPTION="Fragment is an exceptionally powerful, versatile and functional image viewer"
HOMEPAGE="https://www.fragmentapp.info/"

SRC_URI="https://github.com/ferion11/danrepo/releases/download/fragment_mirror/${PN}-${PV}.tar.xz"

SLOT="0"
KEYWORDS="~amd64"
LICENSE="freedist"
IUSE=""
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/glib:2
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /opt
	doins -r "${S}/fragment"
	dosym ../../opt/fragment/fragment /usr/bin/fragment
}
