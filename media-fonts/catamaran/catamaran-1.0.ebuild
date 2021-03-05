# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Catamaran is a 9 weight Tamil type-family"
HOMEPAGE="https://github.com/VanillaandCream/Catamaran-Tamil"

EGIT_COMMIT="7559b4906f9c9148fb22c6f89508c3053a78a296"
SRC_URI="https://github.com/VanillaandCream/Catamaran-Tamil/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/Catamaran-Tamil-${EGIT_COMMIT}/Fonts"
FONT_SUFFIX="ttf"
