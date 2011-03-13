# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Gnuclad"
HOMEPAGE="https://launchpad.net/gnuclad/"
SRC_URI="http://launchpad.net/gnuclad/trunk/0.2/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
    local myconf="--prefix=/usr"
    econf ${myconf} || die "econf failed"
    emake || die "emake failed"
}

src_install() {
    emake DESTDIR="${D}" install || die "emake install failed"
}
