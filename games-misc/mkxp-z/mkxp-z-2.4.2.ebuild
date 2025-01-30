# This is a clusterfuck. ``ruby-single`` is basically useless!
# I'm just gonna implement it manually.

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

inherit meson

DESCRIPTION="Reimplementation of RPG Maker XP's runner"
HOMEPAGE="https://github.com/mkxp-z/mkxp-z"
SRC_URI="https://github.com/mkxp-z/mkxp-z/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT=0

# TODO: make theora dep optional
RDEPEND="
    ruby_targets_ruby31? ( dev-lang/ruby:3.1 )
    ruby_targets_ruby32? ( dev-lang/ruby:3.2 )
    ruby_targets_ruby33? ( dev-lang/ruby:3.3 )
    ruby_targets_ruby34? ( dev-lang/ruby:3.4 )

    >=dev-games/physfs-2.1
    media-libs/openal[sdl]

    media-libs/libtheora
    media-libs/libvorbis
    media-libs/libogg

    x11-libs/pixman

    media-libs/libsdl2[opengl]
    media-libs/sdl2-ttf
    media-libs/sdl2-sound[vorbis,wav]
    media-libs/libpng:=
    app-arch/bzip2:=
    sys-libs/zlib:=
    app-i18n/uchardet

    ssl? ( dev-libs/openssl:0= )
    fluidsynth? ( media-sound/fluidsynth:= )
"
DEPEND="${RDEPEND}"
# meson 0.6 required to find iconv properly
BDEPEND="
    >=dev-build/meson-0.60
    || ( dev-util/xxd app-editors/vim )
"

if [[ ! "${PV}" = "9999" ]]; then
    KEYWORDS="~amd64"
fi
IUSE="
    fluidsynth ssl
    ruby_targets_ruby31 ruby_targets_ruby32 ruby_targets_ruby33 ruby_targets_ruby34
"
REQUIRED_USE="
    ^^ ( ruby_targets_ruby31 ruby_targets_ruby32 ruby_targets_ruby33 ruby_targets_ruby34 )
"

PATCHES=(
    "${FILESDIR}/${PN}-2.4.2-fix-meson-version.patch"
    "${FILESDIR}/${PN}-2.4.2-use-theoradec.patch"
    "${FILESDIR}/${PN}-2.4.2-use-system-iconv.patch"
    "${FILESDIR}/${PN}-2.4.2-use-xxd-plainname.patch"
    "${FILESDIR}/${PN}-2.4.2-remove-custom-install.patch"
    # for my system without a way for sdl to show message boxes...?
    "${FILESDIR}/${PN}-2.4.2-show-msgbox-as-debug.patch"
)

if [[ "${PN}" = "9999" ]]; then
    PATCHES+=("${FILESDIR}/${PN}-2.4.3-use-system-sdl2-image.patch")
fi

src_configure() {
    local ruby_version
    ruby_version=$(echo "${RUBY_TARGETS}" | sed -E 's/^ruby([0-9])([0-9]{1,2})$/\1.\2/')

    # shellcheck disable=SC2207
    local emesonargs=(
        # causes things to violently explode
        -Dstatic_executable=false
        $(meson_use ssl enable-https)
        $(meson_use fluidsynth shared_fluid)
        -Dmri_version="${ruby_version}"
        -Dworkdir_current=true
    )

    meson_src_configure
}

src_install() {
    meson_src_install

    mkdir "${D}"/usr/share/mkxp-z
    insinto /usr/share/mkxp-z
    doins "${S}"/mkxp.json
}

pkg_postinst() {
    elog "You will need to place a mkxp.json file in the directory for your game."
    elog "An example file is available at /usr/shar/mkxp-z/mkxp.json."
    elog "Additionally, you will need to adjust the ``rubyLoadpath`` entry to point"
    elog "to your system Ruby installation; the default definition can be found"
    elog "with ``puts $LOAD_PATH`` in irb."
}
