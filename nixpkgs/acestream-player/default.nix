{ stdenv, fetchFromGitHub, pkgconfig, qt4, openssl, sqlite }:

let
  qtbase = qt4.qtbase;
in stdenv.mkDerivation rec {
  name = "acestream-player";

  src = fetchFromGitHub {
    owner = "Jcryton";
    repo = "acestreamplayer-2.2";
    rev = "5383390bb6baf0d7aedc286059dbdd98c2e52e21";
    sha256 = "06x1x3i5718vn98fx4nhra84773ygz6362z4nc12c8dzgvrcyrd4";
  };

  nativeBuildInputs = [ pkgconfig qt4 ];
  buildInputs = [ openssl sqlite ];

  preConfigure = ''
    cat >config.sh <<EOF
VLC_VERSION="2.2.8"
VLC_URL="http://download.videolan.org/pub/videolan/vlc/2.2.8/vlc-2.28.tar.xz"

HOST="x86_64-linux"

# FOR CROSSCOMPILE: UBUNTU "1604"
UBUNTU="1604"

# QT VERSION "4.8.5" "4.8.6"
QT_VERSION="4.8.7"
CONTRIB_VERSION="0002"
EOF
    ./bootstrap.sh
  '';
}
