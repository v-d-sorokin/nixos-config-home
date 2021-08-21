{ mkDerivation, base, bytestring, Cabal, containers, glib, cairo
, haskell-gi, haskell-gi-base, haskell-gi-overloading, stdenv, text
, transformers
}:
mkDerivation {
  pname = "gi-glib";
  version = "2.0.24";
  sha256 = "b6cbba9e095c3a44138a23c267913cfca484e5047afcedaf69062fb928932a7f";
  setupHaskellDepends = [ base Cabal haskell-gi ];
  libraryHaskellDepends = [
    base bytestring containers haskell-gi haskell-gi-base
    haskell-gi-overloading text transformers
  ];
  libraryPkgconfigDepends = [ glib cairo ];
  homepage = "https://github.com/haskell-gi/haskell-gi";
  description = "GLib bindings";
  license = stdenv.lib.licenses.lgpl21;
}
