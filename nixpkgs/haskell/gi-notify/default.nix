{ mkDerivation, base, bytestring, Cabal, containers, gi-gdkpixbuf
, gi-glib, gi-gobject, haskell-gi, haskell-gi-base
, haskell-gi-overloading, stdenv, text, transformers, gdk_pixbuf, pkgs
}:
mkDerivation {
  pname = "gi-notify";
  version = "0.7.21";
  sha256 = "9a2ef8a0ca2cbd16a8e3284916da14f8e5a28910553de3ae97a93a2a81892e8e";
  setupHaskellDepends = [
    base Cabal gi-gdkpixbuf gi-glib gi-gobject haskell-gi gdk_pixbuf
  ];
  libraryHaskellDepends = [
    base bytestring containers gi-gdkpixbuf gi-glib gi-gobject
    haskell-gi haskell-gi-base haskell-gi-overloading text transformers
  ];
  libraryPkgconfigDepends = [ pkgs.libnotify ];
  homepage = "https://github.com/haskell-gi/haskell-gi";
  description = "Libnotify bindings";
  license = stdenv.lib.licenses.lgpl21;
}
