{ lib, stdenv, fetchurl, fetchgit, libtheora, xvidcore, libGLU, libGL, SDL, SDL_ttf, SDL_mixer
, zlib, minixml, curl, libjpeg, libpng, gettext, cunit, enableEditor?false, pkg-config, zip, unzip, cmake, lua5_1, which }:

let
commit = "8b4533e85fdc0665889ff285e1521432084ee784";
#commit = "e83cd85ac6ca0ea03c737513b5b4e893de4de3cd";
#mySDL2 = SDL2.override { withStatic = true; };

in stdenv.mkDerivation rec {
  name = "ufoai-2.5";
  src = fetchgit {
#    url = "mirror://sourceforge/ufoai/${name}-source.tar.bz2";
#    url = "https://dev.gentoo.org/~chewi/distfiles/ufoai-code-${commit}.zip";
    url = "git://git.code.sf.net/p/ufoai/code";
    rev = commit;
    sha256 = "1g7119w0s1mdfzi9cvvbx1pk0r9d915iknrsh6qn25ky9c98ffka";
#    sha256 = "1prr35j2j9yinz1lmfr9k7pm7v37chy1ibvvw68nd06lxmjpb6zw";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/ufoai/${name}-data.tar";
    sha256 = "1c6dglmm36qj522q1pzahxrqjkihsqlq2yac1aijwspz9916lw2y";
  };

  patches = [ ./ufoai-2.5.0_p20180603-install.patch ./ufoai-2.5.0_p20180603-mxml3.patch ];

  postPatch = ''
    sed -i src/po/ufoai-ru.po -e "s|артифакт|артефакт|g"
    sed -i src/po/ufoai-ru.po -e "s|Артифакт|Артефакт|g"
  '';

  configureFlags = [ "--enable-release" "--enable-sse"
  "--disable-paranoid"
" --disable-memory"
"--disable-testall"
"--disable-ufomodel"
"--disable-ufoslicer"
"--enable-ufo"
"--disable-ufoded"
"--disable-uforadiant"
"--disable-ufo2map"
"--enable-game"
"--target-os=linux"

];

  preConfigure = ''
    tar xvf "${srcData}"
    export configureFlags="$configureFlags --localedir=$out/games/ufo/base/i18n/"
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config gettext zip unzip which ];
  buildInputs = [
    libtheora xvidcore libGLU libGL SDL SDL_ttf SDL_mixer
    curl libjpeg libpng cunit minixml lua5_1
  ];

  NIX_CFLAGS_LINK = "-lgcc_s"; # to avoid occasional runtime error in finding libgcc_s.so.1

  enableParallelBuilding = true;
  preBuild = ''
    # Make the build system a bit happier, will be fixed upstream
    mkdir -p base/{maps,models} contrib/installer/mojosetup/scripts

    # Remove bundled mxml
    rm -r src/libs/mxml/
  '';

  postBuild = "make pk3 lang";

  installPhase = ''
    make install DESTDIR=
  '';

  meta = {
    homepage = "http://ufoai.org";
    description = "A squad-based tactical strategy game in the tradition of X-Com";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = lib.platforms.linux;
    hydraPlatforms = [];
  };
}
