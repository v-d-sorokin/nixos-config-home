{ stdenv, fetchFromGitHub, fetchurl, pkgconfig, qt4, openssl, sqlite
, lua, live555, libdc1394, libavc1394, libshout, libmad, libav, libva
, faad2, twolame, a52dec, dcadec, flac, libcaca, libgcrypt
, automake115x, autoconf }:

let
  qtbase = qt4.qtbase;
  vlc = fetchurl {
    url = "http://download.videolan.org/pub/vlc/2.2.8/vlc-2.2.8.tar.xz";
    sha256 = "1v32snw46rkgbdqdy3dssl2y13i8p2cr1cw1i18r6vdmiy24dw4v";
  };

in stdenv.mkDerivation rec {
  name = "acestream-player";

  src = fetchFromGitHub {
    owner = "Jcryton";
    repo = "acestreamplayer-2.2";
    rev = "5383390bb6baf0d7aedc286059dbdd98c2e52e21";
    sha256 = "06x1x3i5718vn98fx4nhra84773ygz6362z4nc12c8dzgvrcyrd4";
  };

  nativeBuildInputs = [ pkgconfig qt4 automake115x autoconf ];
  buildInputs = [ openssl sqlite lua live555 libdc1394 libavc1394 libshout libmad libav libva faad2 twolame a52dec dcadec flac libcaca libgcrypt ];

  hardeningDisable = [ "format" ];

  configurePhase = ''
    cat >config.sh <<EOF
    VLC_VERSION="2.2.8"
    HOST="x86_64-linux"
    # FOR CROSSCOMPILE: UBUNTU "1604"
    UBUNTU="1604"
    # QT VERSION "4.8.5" "4.8.6"
    QT_VERSION="4.8.7"
    CONTRIB_VERSION="0002"
    EOF
    mkdir -p vlc-2.2.8
    tar xvJf ${vlc}
    ./bootstrap.sh

    mkdir build-ace

    cat >live555.pc <<EOF
    Name: live555
    Description: live555
    Version: ${live555.version}
    Cflags: -I${live555}/include/BasicUsageEnvironment -I${live555}/include/UsageEnvironment -I${live555}/include/groupsock -I${live555}/include/liveMedia
    Libs: -L${live555}/lib
    EOF

    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(pwd)
    pkg-config --cflags live555

    cd build-ace
    ../vlc-2.2.8/configure \
        --prefix=$out \
        --disable-gtk \
        --disable-bluray \
        --enable-nls \
        --enable-sdl \
        --enable-ffmpeg \
        --enable-dxva2 \
        --with-ffmpeg-mp3lame \
        --with-ffmpeg-faac \
        --with-ffmpeg-zlib \
        --enable-faad \
        --enable-flac \
        --enable-theora \
        --enable-live555 \
        --enable-caca \
        --enable-mkv \
        --without-contrib \
        --disable-cddax \
        --disable-vcdx \
        --enable-twolame \
        --disable-dvdread \
        --enable-real \
        --enable-debug \
        --disable-dca \
        --enable-mpc \
        --enable-realrtsp \
        --enable-shout \
        --enable-portaudio \
        --enable-sse \
        --enable-mmx \
        --disable-upnp \
        --disable-fluidsynth \
        --disable-zvbi \
        --disable-telx \
        --disable-libass \
        --disable-projectm \
        --enable-libva \
        --enable-sqlite \
        --disable-linsys

    patch -fp1 <../patches/buildfix/0002-makefile-buildfix.patch
  '';

  preFixup = ''
    mv $out/bin/vlc $out/bin/acestreamplayer
    mv $out/bin/vlc-wrapper $out/bin/acestreamplayer-wrapper
  '';
}
