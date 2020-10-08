# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Symbol fonts required by wps-office."
HOMEPAGE="https://github.com/ferion11/ttf-wps-fonts"
SRC_URI="https://github.com/ferion11/ttf-wps-fonts/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

FONT_SUFFIX="ttf"
