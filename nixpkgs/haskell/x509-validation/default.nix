{ mkDerivation, asn1-encoding, asn1-types, base, byteable
, bytestring, containers, cryptonite_0_24, data-default-class, hourglass
, memory, mtl, pem, stdenv, x509_0_24, x509-store_0_24
}:
mkDerivation {
  pname = "x509-validation";
  version = "1.6.9";
  sha256 = "005m5jxjz5cx3lriayv4a17xa19qc2qxw7kz2f9wvj7hgjnwww44";
  libraryHaskellDepends = [
    asn1-encoding asn1-types base byteable bytestring containers
    cryptonite_0_24 data-default-class hourglass memory mtl pem x509_0_24
    x509-store_0_24
  ];
  homepage = "http://github.com/vincenthz/hs-certificate";
  description = "X.509 Certificate and CRL validation";
  license = stdenv.lib.licenses.bsd3;
}
