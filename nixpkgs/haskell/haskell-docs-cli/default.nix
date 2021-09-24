{ mkDerivation, fetchgit, aeson, ansi-wl-pprint, async, base, bytestring
, containers, directory, exceptions, extra, filepath, hashable
, haskeline, hoogle, hpack, html-conduit, http-client
, http-client-tls, http-types, lib, mtl, network-uri
, optparse-applicative, process, temporary, terminal-size, text
, time, transformers, xml-conduit
}:
mkDerivation {
  pname = "haskell-docs-cli";
  version = "1.0.0.0";
  src = fetchgit {
  "url" = "https://github.com/lazamar/haskell-docs-cli.git";
  "rev" = "9d8032a6a1338d2560b9008971246e10723ba9c8";
#  "date": "2021-09-20T23:49:15+01:00",
#  "path": "/nix/store/k7liy2nhrmsrp31a5l67yhz5fg7lcd9s-haskell-docs-cli",
  "sha256" = "0s8n49x82qqqydc7ydfklm9mrxj4ayq67iixy1h21jg3ydnsxhbc";
#  "fetchLFS": false,
#  "fetchSubmodules": false,
#  "deepClone": false,
#  "leaveDotGit": false
};

  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint async base bytestring containers directory
    exceptions extra filepath hashable haskeline hoogle html-conduit
    http-client http-client-tls http-types mtl network-uri
    optparse-applicative process temporary terminal-size text time
    transformers xml-conduit
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson ansi-wl-pprint async base bytestring containers directory
    exceptions extra filepath hashable haskeline hoogle html-conduit
    http-client http-client-tls http-types mtl network-uri
    optparse-applicative process temporary terminal-size text time
    transformers xml-conduit
  ];
  testHaskellDepends = [
    aeson ansi-wl-pprint async base bytestring containers directory
    exceptions extra filepath hashable haskeline hoogle html-conduit
    http-client http-client-tls http-types mtl network-uri
    optparse-applicative process temporary terminal-size text time
    transformers xml-conduit
  ];
  prePatch = "hpack";
  homepage = "https://github.com/githubuser/haskell-docs-cli#readme";
  description = "Search Hoogle and navigate Hackage from the command line";
  license = lib.licenses.bsd3;
}
