# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod git-r3

DESCRIPTION="Non-fuse kernel driver for exFat and VFat file systems"
HOMEPAGE="https://github.com/barrybingo/exfat-nofuse"

EGIT_REPO_URI="https://github.com/barrybingo/exfat-nofuse"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!sys-fs/fuse-exfat
	 !sys-fs/exfat-linux"
DEPEND="${RDEPEND}"

MODULE_NAMES="exfat(kernel/fs:${S})"
BUILD_TARGETS="all"

src_prepare(){
	sed -i -e "/^KREL/,2d" Makefile || die "sed failed"
	default
}

src_compile(){
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}
