EAPI=3
inherit xorg-2 flag-o-matic

DESCRIPTION="X.Org Xft library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="+cleartype"

RDEPEND=">=x11-libs/libXrender-0.8.2
	x11-libs/libX11
	x11-libs/libXext
	media-libs/freetype
	media-libs/fontconfig
	x11-proto/xproto
	virtual/ttf-fonts"
DEPEND="${RDEPEND}"

src_prepare() {
    if use cleartype; then
        epatch "${FILESDIR}"/${PN}-2.1.14-lcd-cleartype.patch
    fi
}
