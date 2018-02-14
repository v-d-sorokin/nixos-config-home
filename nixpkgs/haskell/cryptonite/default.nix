{ mkDerivation, base, byteable, bytestring, deepseq, ghc-prim
, integer-gmp, memory, stdenv, tasty, tasty-hunit, tasty-kat
, tasty-quickcheck
}:
mkDerivation {
  pname = "cryptonite";
  version = "0.24";
  sha256 = "11js3fg1rbrgy17i0nq19v9w4w28s80zglb6fnlbz6zg8cik3hqp";
  libraryHaskellDepends = [
    base bytestring deepseq ghc-prim integer-gmp memory
  ];
  testHaskellDepends = [
    base byteable bytestring memory tasty tasty-hunit tasty-kat
    tasty-quickcheck
  ];
  homepage = "https://github.com/haskell-crypto/cryptonite";
  description = "Cryptography Primitives sink";
  license = stdenv.lib.licenses.bsd3;
}
