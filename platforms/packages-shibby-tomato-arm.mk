SPECIFIC_PACKAGES = \
	libiconv uclibc-opt \
	$(PERL_PACKAGES) \
	binutils libc-dev gcc \
	ipkg-static \

# iptraf: sys/types.h and linux/types.h conflicting
BROKEN_PACKAGES = \
	buildroot \
	$(UCLIBC_BROKEN_PACKAGES) \
	bluez-hcidump \
	ficy \
	fuppes \
	gtmess \
	rssh \
	sandbox \
	libopensync msynctool obexftp \

PERL_MAJOR_VER := 5.20
PERL_LDFLAGS_EXTRA = -lgcc_s

PSMISC_VERSION := 22.21

#RTORRENT_VERSION := 0.8.0
#RTORRENT_IPK_VERSION := 2

TSHARK_VERSION := 1.2.12
TSHARK_IPK_VERSION := 1

FFMPEG_CONFIG_OPTS := --disable-armv6

ZNC_CONFIG_ARGS:=gl_cv_cc_visibility=true

BINUTILS_VERSION := 2.25
BINUTILS_IPK_VERSION := 1

OPENSSL_VERSION := 1.0.1

E2FSPROGS_VERSION := 1.42.12
E2FSPROGS_IPK_VERSION := 1

M4_VERSION := 1.4.17

BOOST_VERSION := 1_57_0
BOOST_IPK_VERSION := 1
BOOST_EXTERNAL_JAM := no
BOOST_GCC_CONF := tools/build/src/tools/gcc
BOOST_JAM_ROOT := tools/build
BOOST_ADDITIONAL_LIBS := atomic chrono container locale log timer exception

MKVTOOLNIX_VERSION := 5.0.1
MKVTOOLNIX_IPK_VERSION := 1
