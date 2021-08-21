{ stdenv, fetchurl, libtheora, xvidcore, libGLU_combined, SDL, SDL_ttf, SDL_mixer
, curl, libjpeg, libpng, libogg, libvorbis, gettext, cunit, pkgconfig, unzip, zlib }:

stdenv.mkDerivation rec {
  name = "ufoai-2.5";
  src = fetchurl {
    url = "mirror://sourceforge/ufoai/${name}-source.tar.bz2";
    sha256 = "13ra337mjc56kw31m7z77lc8vybngkzyhvmy3kvpdcpyksyc6z0c";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/ufoai/${name}-data.tar";
    sha256 = "1c6dglmm36qj522q1pzahxrqjkihsqlq2yac1aijwspz9916lw2y";
  };

  patches = [ ./ufoai-2.5.0_p20180603-install.patch ]; #./ufoai-2.5.0_p20180603-mxml3.patch ];

  postPatch = ''
    substituteInPlace src/client/battlescape/cl_particle.cpp  --replace "static const int pc_types[PC_NUM_PTLCMDS]" "static const unsigned pc_types[PC_NUM_PTLCMDS]"
  '';

  preConfigure = ''
    tar xvf "${srcData}"
    mkdir -p base/{maps,models} contrib/installer/mojosetup/scripts
    configureFlags="$configureFlags --localedir=$out/games/ufo/base/i18n"
  '';

  configureFlags = [ "--enable-release" "--enable-sse" "--enable-ufo" "--enable-ufoded" "--disable-paranoid" "--disable-memory"
    "--disable-testall" "--disable-ufomodel" "--disable-ufoslicer" "--disable-uforadiant" "--disable-ufo2map" "--enable-game" ];

  buildPhase = ''
    make $makeFlags -j$NIX_BUILD_CORES all
    make $makeFlags -j$NIX_BUILD_CORES lang
  '';

  nativeBuildInputs = [ pkgconfig gettext unzip ];

  buildInputs = [
    libtheora xvidcore libGLU_combined SDL SDL_ttf SDL_mixer
    curl libjpeg libpng cunit zlib libogg libvorbis
  ];

  dontStrip = true;

  hardeningEnable = [ "fortify" ];

  NIX_CFLAGS_COMPILE = "-D_DEFAULT_SOURCE -g -ggdb -Wno-class-memaccess -Wno-implicit-fallthrough -Wno-expansion-to-defined -Wno-misleading-indentation -fno-delete-null-pointer-checks";
#  NIX_CFLAGS_LINK = "-lgcc_s"; # to avoid occasional runtime error in finding libgcc_s.so.1
#  parallelBuild = true;

  meta = {
    homepage = http://ufoai.org;
    description = "A squad-based tactical strategy game in the tradition of X-Com";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
