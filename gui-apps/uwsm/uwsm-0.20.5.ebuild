EAPI=8
PYTHON_COMPAT=( python3_10 python3_11 python3_12 python3_13 )

inherit meson python-single-r1

DESCRIPTION="Universal Wayland Session Manager"
HOMEPAGE="https://github.com/Vladimir-csp/uwsm"
SRC_URI="https://github.com/Vladimir-csp/uwsm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT=0

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# shellcheck disable=SC2016
RDEPEND="${PYTHON_DEPS}
    $(python_gen_cond_dep '
        >=dev-python/dbus-python-1.3.2[${PYTHON_USEDEP}]
        >=dev-python/pyxdg-0.28-r1[${PYTHON_USEDEP}]
    ')
    sys-apps/systemd
    sys-apps/util-linux
"
DEPEND="${RDEPEND}"
BDEPEND="app-text/scdoc"
KEYWORDS="~amd64"
IUSE="+uuctl +uwsm-app"

src_configure() {
    # shellcheck disable=SC2207
	local emesonargs=(
		$(meson_feature uuctl)
		$(meson_feature uwsm-app)
	)

    meson_src_configure
}

src_install() {
    meson_src_install
    python_fix_shebang "${D}"/usr/bin/uwsm
    python_optimize "${D}"/usr/share/uwsm/modules/uwsm
}
