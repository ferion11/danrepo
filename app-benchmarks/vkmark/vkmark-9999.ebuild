# Copyright 2024-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson

DESCRIPTION="vkmark is an extensible Vulkan benchmarking suite"
HOMEPAGE="https://github.com/vkmark/vkmark"
EGIT_REPO_URI="https://github.com/vkmark/vkmark.git"

LICENSE="LGPL-2.1"
SLOT="0"
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

src_install() {
	meson_src_install
}
