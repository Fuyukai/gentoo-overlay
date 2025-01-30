EAPI=8

inherit cmake-multilib

DESCRIPTION="An abstract soundfile decoder"
HOMEPAGE="https://icculus.org/SDL_sound/"
SRC_URI="https://github.com/icculus/SDL_sound/releases/download/v${PV}/SDL2_sound-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/SDL2_sound-${PV}"

LICENSE="ZLIB"
SLOT=0

RDEPEND="media-libs/libsdl2"
DEPEND="${RDEPEND}"
KEYWORDS="~amd64"
IUSE="wav aiff voc flac vorbis pcm modplug mp3 static-libs"

# TODO: Remove in-tree modplug?

multilib_src_configure() {
    # shellcheck disable=SC2207
    local mycmakeargs=(
        -DSDLSOUND_DECODER_WAV=$(usex wav)
        -DSDLSOUND_DECODER_AIFF=$(usex aiff)
        -DSDLSOUND_DECODER_AU=false
        -DSDLSOUND_DECODER_VOC=$(usex voc)
        -DSDLSOUND_DECODER_FLAC=$(usex flac)
        -DSDLSOUND_DECODER_VORBIS=$(usex vorbis)
        -DSDLSOUND_DECODER_RAW=$(usex pcm)
        -DSDLSOUND_DECODER_MODPLUG=$(usex modplug)
        -DSDLSOUND_DECODER_MP3=$(usex mp3)
        -DSDLSOUND_BUILD_STATIC=$(usex static-libs)
    )

    cmake_src_configure
}
