# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="vkmark is an extensible Vulkan benchmarking suite"
HOMEPAGE="https://github.com/vkmark/vkmark"

EGIT_COMMIT="83a128d65b1adddfacb4fa2e555a7e90817a7266"
SRC_URI="https://github.com/vkmark/vkmark/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/mesa
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	media-libs/assimp
	media-libs/glm
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/meson
"

S="${WORKDIR}/vkmark-${EGIT_COMMIT}"

src_install() {
	meson_src_install
}
