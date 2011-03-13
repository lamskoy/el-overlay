# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libzen/libzen-0.4.17.ebuild,v 1.1 2010/12/30 07:51:39 radhermit Exp $

EAPI="2"

inherit autotools multilib

MY_PN="ZenLib"
DESCRIPTION="Shared library for libmediainfo and mediainfo"
HOMEPAGE="http://sourceforge.net/projects/zenlib"
SRC_URI="mirror://sourceforge/zenlib/${MY_PN}%20-%20Sources/${PV}/${PN}_${PV}.tar.bz2"

LICENSE="as-is ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc static-libs"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_PN}/Project/GNU/Library"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-shared \
		--enable-unicode \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd "${WORKDIR}/${MY_PN}/Source/Doc"
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${PN}.pc" || die

	for x in ./ Base64 Format/Html Format/Http HTTP_Client TinyXml; do
		insinto "/usr/include/${MY_PN}/${x}"
		doins "${WORKDIR}/${MY_PN}/Source/${MY_PN}/${x}/"*.h || die
	done

	dodoc "${WORKDIR}/${MY_PN}/"*.txt
	if use doc; then
		dohtml "${WORKDIR}/${MY_PN}/Source/Doc/Documentation.html" || die
		dohtml -r "${WORKDIR}/${MY_PN}/Doc" || die
	fi
}
