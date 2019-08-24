{ stdenv, fetchurl, unzip, python2Packages, gettext, makeWrapper, vlc, sopcast, hicolor_icon_theme }:
stdenv.mkDerivation {
  name = "sopcast-player-0.8.5";
  src = fetchurl {
    url = https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/sopcast-player/source-archive.zip;
    sha256 = "09wjh7zc9c7cj56dimrdgmrpn9x9d88himja1qgnczb4gfksgd4s";
  };

  nativeBuildInputs = [ unzip gettext makeWrapper python2Packages.python python2Packages.setuptools ];
  buildInputs = [ python2Packages.python python2Packages.pygobject2 python2Packages.pyGtkGlade vlc sopcast ];

  unpackPhase = "unzip $src";

  patches = [ ./sopcast-find-vlc.patch ];

  postPatch = ''
      substituteInPlace sopcast-player/trunk/Makefile \
        --replace "msgfmt" "${gettext}/bin/msgfmt" \
        --replace "/usr/bin/python" "${python2Packages.python}/bin/python"
      for file in vlc_1_0_x.py sopcast-player.py vlc.py MimetypeHandler.py vlc_1_1_x.py VLCWidget.py; do
        substituteInPlace "sopcast-player/trunk/lib/$file" \
          --replace "/usr/bin/python" "${python2Packages.python}/bin/python"
      done
  '';

  buildPhase =
  ''
    make PREFIX= DESTDIR=$out/ -C sopcast-player/trunk
  '';
  installPhase =
  ''
    make install PREFIX= DESTDIR=$out/ -C sopcast-player/trunk

    sed -i "s,^\(.*\)/bin/python,PATH=$PATH:${sopcast}/bin/ LD_LIBRARY_PATH=${vlc}/lib/ PYTHONPATH=$PYTHONPATH \1/bin/python,g" $out/bin/sopcast-player
  '';
}
