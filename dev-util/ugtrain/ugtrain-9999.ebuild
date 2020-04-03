# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 multilib

DESCRIPTION="The Universal Elite Game Trainer for CLI (best Linux game trainer)"
HOMEPAGE="https://github.com/ugtrain/ugtrain"
EGIT_REPO_URI="https://github.com/ugtrain/ugtrain"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-glib2 -multilib +procmem"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	local base_config="--prefix=/usr --libdir=/usr/$(get_libdir)"
	./autogen.sh ${base_config}

	local ugtrain_config=${base_config}

	if use multilib; then
		ugtrain_config+=" --enable-multilib"
	fi

	if use glib2; then
		ugtrain_config+=" --enable-glib"
	fi

	if ! use procmem; then
		ugtrain_config+=" --disable-procmem"
	fi

	./configure ${ugtrain_config} || die
}
