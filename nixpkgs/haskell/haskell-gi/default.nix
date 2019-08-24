{ mkDerivation, attoparsec, base, bytestring, Cabal, containers
, directory, doctest, filepath, glib, gobject-introspection
, haskell-gi-base, mtl, pretty-show, process, regex-tdfa, safe
, stdenv, text, transformers, xdg-basedir, xml-conduit
}:
mkDerivation {
  pname = "haskell-gi";
  version = "0.23.0";
  sha256 = "8ad81ef082c71f41c6c6e0afbd8779497da6ffb1e9e7c2b207efe0b56aa7a211";
  libraryHaskellDepends = [
    attoparsec base bytestring Cabal containers directory filepath
    haskell-gi-base mtl pretty-show process regex-tdfa safe text
    transformers xdg-basedir xml-conduit
  ];
  libraryPkgconfigDepends = [ glib gobject-introspection ];
  testHaskellDepends = [ base doctest process ];
  homepage = "https://github.com/haskell-gi/haskell-gi";
  description = "Generate Haskell bindings for GObject Introspection capable libraries";
  license = stdenv.lib.licenses.lgpl21;
}
