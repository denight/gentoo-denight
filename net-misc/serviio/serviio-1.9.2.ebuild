# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="The serviio media streaming server."
HOMEPAGE="http://serviio.org/"
SRC_URI="http://download.serviio.org/releases/serviio-${PV}-linux.tar.gz"


SLOT="0"
RESTRICT="mirror"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.8
	>=virtual/ffmpeg-9
"
DEPEND=""
DOCS="LICENCE.txt NOTICE.txt README.txt RELEASE_NOTES.txt"


src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-gentoo-2.patch"
}

src_install() {
	into "/opt/${PN}"
	for x in ${S}/bin/*; do
		dobin "${x}"
	done

	insinto "/opt/${PN}/lib"
	for x in ${S}/lib/*; do
		doins "${x}"
	done

	insinto "/opt/${PN}/config"
	for x in ${S}/config/*; do
		doins "${x}"
	done
	fowners -R root:serviio "/opt/${PN}/config"
	fperms -R 0640 "/opt/${PN}/config"
	fperms 0750 "/opt/${PN}/config"

	insinto "/var/lib/${PN}/library"
	for x in ${S}/library/*; do
		doins "${x}"
	done
	fowners -R serviio:serviio "/var/lib/${PN}"

	dodoc ${DOCS}
	docinto "legal"
	for x in ${S}/legal/*; do
		dodoc "${x}"
	done

	keepdir "/opt/${PN}/plugins"

	dodir   "/var/log/${PN}"
	keepdir "/var/log/${PN}"
	fowners -R serviio:serviio "/var/log/${PN}"
	fperms  0700 "/var/log/${PN}"

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
}

pkg_preinst() {
	enewgroup serviio
	enewuser serviio -1 -1 "/var/lib/${PN}" "serviio"
}
