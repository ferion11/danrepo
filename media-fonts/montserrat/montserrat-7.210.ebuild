# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Typeface inspired in the city of Montserrat in Buenos Aires"
HOMEPAGE="https://github.com/JulietaUla/Montserrat"
SRC_URI="https://github.com/JulietaUla/Montserrat/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+otf +ttf"

DEPEND="app-arch/unzip"

S="${WORKDIR}/Montserrat-${PV}/fonts"

src_install() {
	if use otf; then
		FONT_S="${S}/otf" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/ttf" FONT_SUFFIX="ttf" font_src_install
	fi
}
