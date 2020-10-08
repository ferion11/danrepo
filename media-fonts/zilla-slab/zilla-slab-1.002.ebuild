# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Mozilla's Zilla Slab Type Family"
HOMEPAGE="https://github.com/mozilla/zilla-slab"
SRC_URI="https://github.com/mozilla/zilla-slab/releases/download/v${PV}/Zilla-Slab-Fonts-v${PV}.zip -> ${P}.zip"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+otf +ttf"

DEPEND="app-arch/unzip"

S="${WORKDIR}/zilla-slab"

src_install() {
	if use otf; then
		FONT_S="${S}/otf" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/ttf" FONT_SUFFIX="ttf" font_src_install
	fi
}
