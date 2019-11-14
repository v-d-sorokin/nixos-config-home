{stdenv, fetchurl, patchelf, glibc, python2, python2Packages, makeWrapper, unzip, libxslt, libxml2, libappindicator-gtk2
}:

stdenv.mkDerivation rec {
  name = "acestream-engine";
  version = "3.1.49";

  src = fetchurl {
    url = "http://acestream.org/downloads/linux/acestream_${version}_ubuntu_18.04_x86_64.tar.gz";
    sha256 = "17p15qh14wcgd2i25namfid3hj0dc1ppy3vkv82pr97n73f7pvfj";
  };

  nativeBuildInputs = [ patchelf makeWrapper unzip ];

  unpackPhase = ''
    mkdir source
    tar xzf $src -C source
    unzip ${python2Packages.setuptools.src}
  '';

  installPhase = ''
    install -d $out
    cp source/acestreamengine $out/
    cp source/start-engine $out/

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/acestreamengine
    patchelf --set-rpath "${glibc.out}/lib:${python2}/lib" $out/acestreamengine

    wrapProgram $out/acestreamengine \
      --set PYTHONPATH "$PYTHONPATH:$out/lib:${python2Packages.apsw}/${python2.sitePackages}:${python2Packages.pygtk}/${python2.sitePackages}/gtk-2.0:${python2Packages.pygobject2}/${python2.sitePackages}:${python2Packages.pygobject2}/${python2.sitePackages}/gtk-2.0:${python2Packages.pycairo}/${python2.sitePackages}:${libappindicator-gtk2}/${python2.sitePackages}" \
      --set LD_LIBRARY_PATH "${libxslt.out}/lib:${libxml2.out}/lib"

    cp -r source/lib $out/
    cp -r source/data $out/

    cp -r setuptools*/pkg_resources $out/lib
  '';
}
