# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils flag-o-matic linux-mod linux-info

MY_P="oss-v$(ver_cut 1-2)-build$(ver_cut 3)-src-gpl"

DESCRIPTION="Open Sound System - portable, mixing-capable, high quality sound system for Unix"
HOMEPAGE="http://developer.opensound.com"
SRC_URI="http://www.4front-tech.com/developer/sources/stable/gpl/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libsalsa midi ogg oss_driver pax_kernel vmix_fixedpoint"

RESTRICT="mirror"

DEPEND="!media-sound/oss-devel
	libsalsa? ( media-libs/alsa-lib )
	x11-libs/gtk+:2
	ogg? ( media-libs/libvorbis )
	oss_driver? ( media-sound/oss-driver )
	sys-apps/gawk
	sys-kernel/linux-headers"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mkdir "${WORKDIR}/build"

	einfo "Replacing init script with gentoo friendly one ..."
	cp "${FILESDIR}/init.d/oss" "${S}/setup/Linux/oss/etc/S89oss" || die
	cp "${FILESDIR}/sbin/soundon" "${S}/setup/Linux/sbin/soundon" || die
	cp "${FILESDIR}/sbin/soundoff" "${S}/setup/Linux/sbin/soundoff" || die

	if ! use ogg ; then
		sed -e "s;OGG_SUPPORT=YES;OGG_SUPPORT=NO;g" \
			-i "${S}/configure" || die
	fi

	#NOTE: getting goods patchs guides for oss4 from: http://ossnext.trueinstruments.com/forum/viewforum.php?f=3

	# Adding patch ossdetect with glibc starting with version 2.23
	eapply "${FILESDIR}/${P}-sys-libs_glibc-2.23_ossdetect_fix.patch"

	# Adding patch to work with kernel 5.3.0
	eapply "${FILESDIR}/${P}-kernel503.patch"

	eapply "${FILESDIR}/${P}-galaxy.patch"
	eapply "${FILESDIR}/${P}-ossvermagic.patch"
	eapply "${FILESDIR}/${P}-seawright.patch"
	eapply "${FILESDIR}/${P}-as-needed-strip.patch"

	if use pax_kernel ; then
		eapply "${FILESDIR}/pax_kernel.patch"
	fi

	for deprecated_card in ${DEPRECATED_CARDS} ; do
		ln -s "${S}/attic/drv/oss_${deprecated_card}" "${S}/kernel/drv/oss_${deprecated_card}"
	done

	sed -e "s/-Werror//g" \
		-i "phpmake/Makefile.php" "setup/Linux/oss/build/install.sh" "setup/srcconf_linux.inc" || die

	sed -e "s;grc_max=3;grc_max=6;g" \
		-i "${S}/setup/srcconf.c" || die
	sed -e "s;GRC_MAX_QUALITY=3;GRC_MAX_QUALITY=6;g" \
		-i "${S}/configure" || die

	# Build at the "build" directory instead of /tmp
	sed -e "s;/tmp/;${WORKDIR}/build/;g" \
		-i "${S}/setup/Linux/build.sh" || die

	# Remove bundled libflashsupport. Deprecated since 2006.
	rm "${S}/oss/lib/flashsupport.c" || die
	sed -e "/^.*flashsupport.c .*/d" \
		-i "${S}/setup/Linux/build.sh" \
		-i "${S}/setup/Linux/oss/build/install.sh" || die

	sed -e s/"| gzip -9"//g -i "${S}/setup/Linux/build.sh"
	sed -e s/"\.gz"//g -i "${S}/setup/Linux/build.sh"

	eapply_user
}

src_configure() {
	local oss_config="$(use libsalsa && echo || echo --enable-libsalsa=NO)
		--config-midi=$(use midi && echo YES || echo NO)
		--config-vmix=$(use vmix_fixedpoint && echo FIXEDPOINT || echo FLOAT)
		--no-regparm
		--only-drv=osscore"

	cd "${WORKDIR}/build" && "${S}/configure" ${oss_config} || die

	sed -e "s;'#define CONFIG_OSS_GRC_MAX_QUALITY 3';'#define CONFIG_OSS_GRC_MAX_QUALITY 6';" \
		-i "${WORKDIR}/build/kernel/framework/include/local_config.h" || die

	set_arch_to_kernel
}

src_compile() {
	filter-flags -fPIC # FL-1536

	cd "${WORKDIR}/build" && emake build || die

	cd "${WORKDIR}/build/prototype/usr/lib/oss"
	ln -s objects.noregparm objects
	ln -s modules.noregparm modules

	rm -rf "${WORKDIR}/build/prototype/usr/lib/oss/build"
}

src_install() {
	newinitd "${FILESDIR}/init.d/oss" oss || die
	#doenvd "${FILESDIR}/env.d/99oss" || die

	cp -R "${WORKDIR}"/build/prototype/* "${D}" || die

	local libdir=$(get_libdir)
	insinto /usr/${libdir}/pkgconfig
	doins "${FILESDIR}"/OSSlib.pc || die

	local oss_libs="libOSSlib.so libossmix.so"
	use libsalsa && oss_libs+=" libsalsa.so.2.0.0"

	for oss_lib in ${oss_libs} ; do
		dosym oss/lib/${oss_lib} /usr/lib/${oss_lib} || die
	done

	dosym ../lib/oss/include /usr/include/oss || die
}

pkg_postinst() {
	ewarn "In order to use OSSv4 you must run"
	ewarn "/etc/init.d/oss start"
	ewarn "If you are upgrading from a previous build of OSSv4 you must run"
	ewarn "/etc/init.d/oss restart"
	ewarn "In case of upgrading from a previous build or reinstalling current one"
	ewarn "You might need to remove /lib/modules/${KV_FULL}/kernel/oss"
}
