# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{13..15} )

inherit autotools python-single-r1

DESCRIPTION="Memory scanner for Linux"
HOMEPAGE="https://github.com/scanmem/scanmem"

EGIT_COMMIT="6fc5e7f170f5a7fe97624b0dc870612aeb944e53"
SRC_URI="https://github.com/scanmem/scanmem/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui static-libs"

REQUIRED_USE="gui? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}
	gui? (
		${PYTHON_DEPS}
		dev-python/pygobject:3
		sys-auth/polkit
		x11-libs/gtk+:3
	)"

BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/scanmem-${EGIT_COMMIT}"

pkg_setup() {
	use gui && python-single-r1_pkg_setup
}

src_prepare() {
	default
	sed -i "/CFLAGS/d" Makefile.am || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--docdir="/usr/share/doc/${PF}"
		--with-readline
		$(use_enable gui)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if use gui ; then
		docinto gui
		dodoc gui/{README,TODO}
		python_fix_shebang "${ED}"
	fi
	find "${ED}" -type f -name "*.la" -delete || die
}
