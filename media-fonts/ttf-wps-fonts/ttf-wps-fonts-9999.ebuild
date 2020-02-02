# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 font

DESCRIPTION="Symbol fonts required by wps-office."
HOMEPAGE="https://github.com/ferion11/ttf-wps-fonts"

EGIT_REPO_URI="https://github.com/ferion11/ttf-wps-fonts.git"
EGIT_CLONE_TYPE="shallow"

LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="ttf"
