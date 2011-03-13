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
IUSE=""

DEPEND="dev-libs/glib:2
dev-libs/dbus-glib
dev-lang/lua
dev-lua/luaposix"

RDEPEND="${DEPEND}"

CONFIG_CHECK="CGROUPS
	CGROUP_FREEZER
	CGROUP_DEVICE
	CGROUP_MEM_RES_CTLR
	CGROUP_MEM_RES_CTLR_SWAP
	CGROUP_MEM_RES_CTLR_SWAP_ENABLED
	CGROUP_SCHED
	FAIR_GROUP_SCHED
	RT_GROUP_SCHED
	BLK_CGROUP
	CFQ_GROUP_IOSCHED"

src_prepare() {
	# remove systemd support
	sed -i "168,169d" CMakeLists.txt
}

src_install() {
	cmake-utils_src_install
	newinitd $FILESDIR/ulatencyd.init ulatencyd
}
