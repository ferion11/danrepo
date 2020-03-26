# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Lato is a sanserif typeface family."
HOMEPAGE="http://www.latofonts.com"
SRC_URI="http://www.latofonts.com/download/Lato2OFL.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}/Lato2OFL"
FONT_S="${S}"
FONT_SUFFIX="ttf"
