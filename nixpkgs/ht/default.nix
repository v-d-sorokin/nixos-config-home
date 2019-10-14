{ stdenv, fetchFromGitHub, autoconf, automake, ncurses, texinfo, yacc, flex, xorg, lzo }:
stdenv.mkDerivation rec {
  name = "ht-${version}";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "sebastianbiallas";
    repo = "ht";
    rev = "e9e63373148da5d7df397d8075740d8c096ecb1d";
    sha256 = "0lqlkxw9npll3mz0s69g96n59cga45d07wms16k2wczf7n0mdi20";
  };

  buildInputs = [ lzo xorg.libX11 ];
  nativeBuildInputs = [ autoconf automake ncurses texinfo yacc flex ];

  preConfigure = ''
    ./autogen.sh
  '';

  preBuild = ''
    make || true
    make htdoc.h
  '';
}
