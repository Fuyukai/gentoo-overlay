# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4-r1

EAPI=8

CRATES="
	ansi_term@0.12.1
	arrayvec@0.5.2
	atty@0.2.14
	bitflags@1.3.2
	cfg-if@1.0.0
	clap@2.34.0
	getrandom@0.1.16
	hermit-abi@0.1.19
	kernel32-sys@0.2.2
	libc@0.2.151
	numtoa@0.1.0
	ppv-lite86@0.2.17
	rand@0.7.3
	rand_chacha@0.2.2
	rand_core@0.5.1
	rand_hc@0.2.0
	redox_syscall@0.2.16
	redox_termios@0.1.3
	strsim@0.8.0
	termion@1.5.6
	termsize@0.1.6
	textwrap@0.11.0
	unicode-width@0.1.11
	utf8-chars@1.0.2
	vec_map@0.8.2
	wasi@0.9.0+wasi-snapshot-preview1
	winapi@0.2.8
	winapi@0.3.9
	winapi-build@0.1.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
"

inherit cargo

DESCRIPTION="The good ol' lolcat, now with fearless concurrency."
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/ur0/lolcat"
GIT_COMMIT="abcaac036afd03ca0b304ca889144a2f3b7a4ed3"
SRC_URI="
    ${CARGO_CRATE_URIS}
    https://github.com/ur0/lolcat/archive/${GIT_COMMIT}.zip -> ${P}.zip
"
S="${WORKDIR}/lolcat-${GIT_COMMIT}"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
    >=virtual/rust-1.71
    app-arch/unzip
"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"