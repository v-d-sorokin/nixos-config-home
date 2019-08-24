{ stdenv, fetchgit, cmake, pkgconfig, qt5 }:
stdenv.mkDerivation rec {
  name = "CoolReader-${version}";
  version = "3.1.2";
  src = fetchgit {
    url = "https://git.code.sf.net/p/crengine/crengine";
    rev = "refs/tags/cr${version}-71";
    sha256 = "04rfv2pg75c2kvkq90pn4l2k9y1fdija1ljpd8ciwwm9b1zyyszn";
  };

  buildInputs = [ qt5.qtbase ];
  nativeBuildInputs = [ cmake pkgconfig qt5.qttools ];
  
  patchPhase = ''
    echo "target_link_libraries(cr3 Qt5::Widgets)" >> cr3qt/CMakeLists.txt
  '';

  cmakeFlags = "-D GUI=QT5 -D CMAKE_BUILD_TYPE=Release -D MAX_IMAGE_SCALE_MUL=2 -D DOC_DATA_COMPRESSION_LEVEL=3 -D DOC_BUFFER_SIZE=0x1400000 ..";
}
