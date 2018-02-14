{ mkDerivation, asn1-encoding, asn1-types, base, bytestring
, containers, cryptonite_0_24, directory, filepath, mtl, pem, stdenv, tasty, tasty-hunit
, x509_0_24
}:
mkDerivation {
  pname = "x509-store";
  version = "1.6.5";
  sha256 = "1lg9gy0bmzjmlk4gfnzx2prfar1qha4hfjsw8yvjg33zm0fv3ahs";
  libraryHaskellDepends = [
    asn1-encoding asn1-types base bytestring containers cryptonite_0_24
    directory filepath mtl pem tasty tasty-hunit x509_0_24
  ];
  homepage = "http://github.com/vincenthz/hs-certificate";
  description = "X.509 collection accessing and storing methods";
  license = stdenv.lib.licenses.bsd3;
}
