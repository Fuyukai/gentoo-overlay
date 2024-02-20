# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
VALA_USE_DEPEND="vapigen"
inherit vala meson python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wmww/${PN}"
else
	SRC_URI="https://github.com/wmww/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Library to create panels and other desktop components for Wayland using the Layer Shell protocol and GTK4"
HOMEPAGE="https://github.com/wmww/gtk4-layer-shell"

LICENSE="MIT"
SLOT="0"
IUSE="examples gtk-doc introspection test vala"
RESTRICT="!test? ( test )"

REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=gui-libs/gtk-4.12.4:4[introspection?,wayland]
	>=dev-libs/wayland-1.10.0
	>=dev-libs/wayland-protocols-1.16
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
	x11-base/xorg-proto
	gtk-doc? ( dev-util/gtk-doc )
	test? ( ${PYTHON_DEPS} )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_use gtk-doc docs)
		$(meson_use test tests)
		$(meson_use introspection)
		$(meson_use vala vapi)
	)
	meson_src_configure
}
