# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Yrsa is Latin-only type family by Rosetta, intended for continuous reading"
HOMEPAGE="https://github.com/rosettatype/yrsa-rasa"
SRC_URI="https://github.com/rosettatype/yrsa-rasa/releases/download/v${PV}/Yrsa-fonts-v${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+otf +ttf"

DEPEND="app-arch/unzip"

S="${WORKDIR}/Yrsa"

src_install() {
	if use otf; then
		FONT_S="${S}/otf" FONT_SUFFIX="otf" font_src_install
	fi
	if use ttf; then
		FONT_S="${S}/ttf" FONT_SUFFIX="ttf" font_src_install
	fi
}
