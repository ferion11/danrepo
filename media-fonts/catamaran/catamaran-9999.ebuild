# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 font

DESCRIPTION="Catamaran is a 9 weight Tamil type-family"
HOMEPAGE="https://github.com/VanillaandCream/Catamaran-Tamil"

EGIT_REPO_URI="https://github.com/VanillaandCream/Catamaran-Tamil.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${S}/Fonts"
FONT_SUFFIX="ttf"
