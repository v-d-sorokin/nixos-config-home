{ stdenv, fetchurl, patchelf, pkgsi686Linux }:
stdenv.mkDerivation {
  name = "sopcast-3.2.6";
  srcs = [ (fetchurl {
    url = http://download.sopcast.com/download/sp-auth.tgz;
    sha256 = "1ncihfpgk15kjszi8ywfvggsac4pywrnpw05bqchqjymkm10g92w";
  })
#  (fetchurl {
#    url = http://www.sopcast.com/download/libstdcpp5.tgz;
#    sha256 = "00kb6zzm2lq0drcjrghagd8y5jrzkdqr93z6i4g6sx38b34dhs3a";
#  })
  ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase =
  ''
    for src in $srcs; do
      tar xvfz $src
     done
  '';
  installPhase =
  ''
    install -d $out/bin/
    install -m 0755 sp-auth/sp-sc-auth $out/bin/
    ${patchelf}/bin/patchelf --set-interpreter "${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2" $out/bin/sp-sc-auth
    ${patchelf}/bin/patchelf --set-rpath "${pkgsi686Linux.libstdcxx5.out}/lib" $out/bin/sp-sc-auth
  '';
}
