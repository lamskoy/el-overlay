# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils linux-info

EAPI=3

DESCRIPTION="Daemon to minimize latency on a linux system using cgroups"
HOMEPAGE="https://github.com/poelzi/ulatencyd"
SRC_URI="https://github.com/downloads/poelzi/${PN}/${P}.tar.gz"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd openrc gui"

DEPEND="dev-libs/glib:2
dev-libs/dbus-glib
dev-lang/lua
dev-lua/luaposix
>=dev-lang/python-2.2
systemd? ( sys-apps/systemd )
openrc? ( sys-apps/openrc )
gui? ( dev-python/PyQt4[X] )
"

RDEPEND="${DEPEND}"

CONFIG_CHECK="CGROUPS
	CGROUP_FREEZER
	CGROUP_DEVICE
	CGROUP_MEM_RES_CTLR
	CGROUP_MEM_RES_CTLR_SWAP
	CGROUP_SCHED
	FAIR_GROUP_SCHED
	RT_GROUP_SCHED
	BLK_CGROUP
	CFQ_GROUP_IOSCHED"

if kernel_is -ge 2 6 37; then
CONFIG_CHECK="${CONFIG_CHECK}
	CGROUP_MEM_RES_CTLR_SWAP_ENABLED"
fi

src_prepare() {
    # do not install systemd config
    if ! use systemd; then
	epatch "${FILESDIR}"/"${PN}"-0.4.8-nosystemd.patch
    fi
    # use python2 abi
    epatch "${FILESDIR}"/"${PN}"-0.4.8-python2.patch
}

src_configure() {
    mycmakeargs=(
	-DDEVELOP_MODE=FALSE
	-DCMAKE_INSTALL_PREFIX=/usr
	-DCMAKE_BUILD_TYPE=RelWithDebInfo
    )
    cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use openrc; then
		newinitd $FILESDIR/ulatencyd-openrc.init ulatencyd
	else
		newinitd $FILESDIR/ulatencyd.init ulatencyd
	fi
}
