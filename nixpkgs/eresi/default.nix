{ stdenv, fetchFromGitHub, openssl, readline, ncurses, which }:
stdenv.mkDerivation rec {
  name = "eresi-${version}";
  version = "0.8";
  src = fetchFromGitHub {
    owner = "thorkill";
    repo = "eresi";
    rev = "d0facbfd7499649892dd3cbdb7e452ecb5c06520";
    sha256 = "06mnwriwm9ggyicr7b8skhzg1kmwfvqzr6k4m4bzm40zrxsc9ikr";
  };

  patches = [ ./fix-printf.patch ];

  configurePhase = ''
    sed -i "s|-ltermcap|-lncurses|g" ./configure
    sed -i "s|~/.eresirc|/|g" ./configure
    sed -i "s|~/.elfshrc|/|g" ./configure
    sed -i "s|~/.e2dbgrc|/|g" ./configure
    sed -i "s|~/.etracerc|/|g" ./configure
    sed -i "s|~/.kernshrc|/|g" ./configure
    ./configure --enable-32-64 --enable-readline --enable-m64 --enable-gstabs+ --prefix=""
  '';
  buildInputs = [ openssl readline ncurses ];
  nativeBuildInputs = [ which ];

  installPhase = ''
    make install DESTDIR=$out
    make install64 DESTDIR=$out
  '';
}
