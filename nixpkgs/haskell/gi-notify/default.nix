{ mkDerivation, pkgs, base, bytestring, Cabal, containers, gi-gdkpixbuf
, gi-glib, gi-gobject, haskell-gi, haskell-gi-base, haskell-gi-overloading, libnotify
, stdenv, text, transformers, gtk3
}:
(mkDerivation {
  pname = "gi-notify";
  version = "0.7.14";
  sha256 = "12ahyx3pn2pf63n22pa8qkwgh36yrdza2hw3n6khqws814g2f0ay";
  setupHaskellDepends = [ base Cabal haskell-gi ];
  libraryHaskellDepends = [
    base bytestring containers gi-gdkpixbuf gi-glib gi-gobject
    haskell-gi haskell-gi-base haskell-gi-overloading text transformers
  ];
  libraryPkgconfigDepends = [ libnotify ];
  homepage = "https://github.com/haskell-gi/haskell-gi";
  description = "Libnotify bindings";
  license = stdenv.lib.licenses.lgpl21;
}) {inherit (pkgs) libnotify;}
