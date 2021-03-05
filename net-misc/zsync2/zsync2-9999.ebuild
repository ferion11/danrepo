# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="zsync2 is one improved version of zsync"
HOMEPAGE="https://github.com/AppImage/zsync2"
EGIT_REPO_URI="https://github.com/AppImage/zsync2.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/zlib
	net-libs/gnutls
	net-misc/curl
	dev-libs/openssl
	virtual/ssh
"
DEPEND="${RDEPEND}"

src_compile() {
	mkdir build
	cd build
	cmake .. -DUSE_SYSTEM_CURL=1 -DBUILD_CPR_TESTS=0
	emake
}

src_install() {
	cd build
	emake install DESTDIR="${D}"
}
