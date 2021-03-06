# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xtrlock/xtrlock-2.6.ebuild,v 1.1 2014/01/13 15:29:04 jer Exp $

EAPI=5
inherit toolchain-funcs eutils

#Note: there's no difference vs 2.0-12
MY_P=${P/-/_}

DESCRIPTION="A simplistic screen locking program for X"
SRC_URI="mirror://debian/pool/main/x/xtrlock/${MY_P}.tar.gz"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/x/xtrlock/"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-misc/imake"

src_unpack() {
    unpack ${A}
    cd "${S}"
    epatch "${FILESDIR}/lock.bitmap.patch"
    epatch "${FILESDIR}/mask.bitmap.patch"
}

src_prepare() {
	sed -i -e 's|".*"|"'"${PV}"'"|g' patchlevel.h || die
}

src_compile() {
	xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS} -DSHADOW_PWD" CC="$(tc-getCC)" \
		EXTRA_LDOPTIONS="${LDFLAGS}" xtrlock
}

src_install() {
	dobin xtrlock
	chmod u+s "${D}"/usr/bin/xtrlock
	newman xtrlock.man xtrlock.1
	dodoc debian/changelog
}
