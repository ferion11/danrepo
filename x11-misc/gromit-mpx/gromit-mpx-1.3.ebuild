# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Gromit-MPX is a multi-pointer GTK3 port of the original Gromit"
HOMEPAGE="https://github.com/bk138/gromit-mpx"
SRC_URI="https://github.com/bk138/gromit-mpx/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/gtk+:3
	dev-libs/libappindicator:3
	x11-libs/libX11
	>=x11-apps/xinput-1.3
"
DEPEND="${RDEPEND}"
