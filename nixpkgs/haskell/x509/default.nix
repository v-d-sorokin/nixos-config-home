{ mkDerivation, asn1-encoding, asn1-parse, asn1-types, base
, bytestring, containers, cryptonite_0_24, hourglass, memory, mtl, pem
, stdenv, tasty, tasty-quickcheck
}:
mkDerivation {
  pname = "x509";
  version = "1.7.2";
  sha256 = "0yyfw07bw73gkh93z653lnncc30wj3g3rf26cwxjpyxvwalia0yw";
  libraryHaskellDepends = [
    asn1-encoding asn1-parse asn1-types base bytestring containers
    cryptonite_0_24 hourglass memory mtl pem
  ];
  testHaskellDepends = [
    asn1-types base bytestring cryptonite_0_24 hourglass mtl tasty
    tasty-quickcheck
  ];
  homepage = "http://github.com/vincenthz/hs-certificate";
  description = "X509 reader and writer";
  license = stdenv.lib.licenses.bsd3;
}
