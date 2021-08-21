{ mkDerivation, base, bytestring, Cabal, containers, haskell-gi
, haskell-gi-base, haskell-gi-overloading, stdenv, text
, transformers, xlibsWrapper
}:
mkDerivation {
  pname = "gi-xlib";
  version = "2.0.9";
  sha256 = "00d53dae1ce858856a044ee6ef945eced0dc3fe8f7d9c1f4c56ece06c68fc20a";
  setupHaskellDepends = [ base Cabal haskell-gi ];
  libraryHaskellDepends = [
    base bytestring containers haskell-gi haskell-gi-base
    haskell-gi-overloading text transformers
  ];
  libraryPkgconfigDepends = [ xlibsWrapper ];
  homepage = "https://github.com/haskell-gi/haskell-gi";
  description = "xlib bindings";
  license = stdenv.lib.licenses.lgpl21;
}
