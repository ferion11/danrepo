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

DEPRECATED_CARDS="allegro als3xx als4k digi32 maestro neomagic s3vibes vortex"

CARDS="ali5455 atiaudio audigyls audiocs audioloop audiopci cmi878x cmpci cs4281 cs461x
	digi96 emu10k1x envy24 envy24ht fmedia geode hdaudio ich imux madi midiloop
	midimix sblive sbpci sbxfi solo trident usb userdev via823x via97 ymf7xx
	${DEPRECATED_CARDS}"

IUSE="alsa gtk midi ogg pax_kernel vmix_fixedpoint"

for card in ${CARDS} ; do
	IUSE+=" oss_cards_${card}"
done

RESTRICT="mirror"

DEPEND="!media-sound/oss-devel
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	ogg? ( media-libs/libvorbis )
	sys-apps/gawk
	sys-kernel/linux-headers"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mkdir "${WORKDIR}/build"

	einfo "Replacing init script with gentoo friendly one ..."
	cp "${FILESDIR}/init.d/oss" "${S}/setup/Linux/oss/etc/S89oss" || die

	if ! use ogg ; then
		sed -e "s;OGG_SUPPORT=YES;OGG_SUPPORT=NO;g" \
			-i "${S}/configure" || die
	fi

	#NOTE: getting goods patchs guides for oss4 from: http://ossnext.trueinstruments.com/forum/viewforum.php?f=3

	# Adding patch ossdetect with glibc starting with version 2.23
	eapply "${FILESDIR}/${P}-sys-libs_glibc-2.23_ossdetect_fix.patch"

	# Adding patch to work with kernel 5.3.0
	eapply "${FILESDIR}/${P}-kernel503.patch"

	eapply "${FILESDIR}/${P}-noPIC.patch"
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

	eapply_user
}

src_configure() {
	local oss_config="$(use alsa && echo || echo --enable-libsalsa=NO)
		--config-midi=$(use midi && echo YES || echo NO)
		--config-vmix=$(use vmix_fixedpoint && echo FIXEDPOINT || echo FLOAT)
		--no-regparm
		--only-drv=osscore"
	for card in ${CARDS} ; do
		if use oss_cards_${card} ; then
			oss_config+=",oss_${card}"
		fi
	done

	cd "${WORKDIR}/build" && "${S}/configure" ${oss_config} || die

	sed -e "s;'#define CONFIG_OSS_GRC_MAX_QUALITY 3';'#define CONFIG_OSS_GRC_MAX_QUALITY 6';" \
		-i "${WORKDIR}/build/kernel/framework/include/local_config.h" || die

	set_arch_to_kernel
}

src_compile() {
	filter-flags -fPIC # FL-1536

	cd "${WORKDIR}/build" && emake build || die
}

src_install() {
	OSSLIBDIR="/usr/lib/oss"
	UNAME=`uname -r`
	KERNELDIR="/lib/modules/$UNAME/build"

	cd "${WORKDIR}/build/prototype/usr/lib/oss"
	ln -s objects.noregparm objects
	ln -s modules.noregparm modules

	cd "${WORKDIR}/build/prototype/usr/lib/oss/build"
	cp -f ../objects/osscore.o osscore_mainline.o
	rm -f Makefile
	sed -i "1s/.*/OSSLIBDIR\=../" Makefile.osscore
	sed -i 's/\/usr/..\/..\/../g' Makefile.osscore
	ln -s Makefile.osscore Makefile
	cp -f ../objects/osscore.o osscore_mainline.o
	rm -f osscore_lnk.c
	ln -s osscore.c osscore_lnk.c
	ln -s ../include/internals/*.h ./
	ln -s ../include/sys/*.h ./
	make KERNELDIR="$KERNELDIR" > build.list
	#-------------------------------------------------------------

	newinitd "${FILESDIR}/init.d/oss" oss || die
	#doenvd "${FILESDIR}/env.d/99oss" || die

	cp -R "${WORKDIR}"/build/prototype/* "${D}" || die

	local libdir=$(get_libdir)
	insinto /usr/${libdir}/pkgconfig
	doins "${FILESDIR}"/OSSlib.pc || die

	local oss_libs="libOSSlib.so libossmix.so"
	use alsa && oss_libs+=" libsalsa.so.2.0.0"

	for oss_lib in ${oss_libs} ; do
		dosym oss/lib/${oss_lib} /usr/lib/${oss_lib} || die
	done

	dosym ../lib/oss/include /usr/include/oss || die
}

pkg_postinst() {
	UPDATE_MODULEDB=true
	linux-mod_pkg_postinst

	ewarn "In order to use OSSv4 you must run"
	ewarn "/etc/init.d/oss start"
	ewarn "If you are upgrading from a previous build of OSSv4 you must run"
	ewarn "/etc/init.d/oss restart"
	ewarn "In case of upgrading from a previous build or reinstalling current one"
	ewarn "You might need to remove /lib/modules/${KV_FULL}/kernel/oss"
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
