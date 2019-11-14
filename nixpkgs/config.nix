{ pkgs }:
{
  allowUnfree = true;
#  binaryCaches = [
#    "https://cachix.cachix.org"
#    "https://all-hies.cachix.org"
#  ];
#  binaryCachePublicKeys = [
#    "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
#    "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
#  ];

  packageOverrides = super1:
  let
    sources = ~/Sources;
  in {
    sopcast = super1.callPackage ./sopcast {};
    sopcast-cli = super1.callPackage ./sopcast-cli {};
    coolreader = super1.callPackage ./coolreader {};
    acestream-player = super1.callPackage ./acestream-player {};
    acestream-engine = super1.callPackage ./acestream-engine {};

    haskellPackages = super1.haskellPackages.override {
      overrides = self: super: rec {
        cabal-helper = self.callPackage ./haskell/cabal-helper {
          cabal-plan = self.callPackage ./haskell/cabal-plan {};
          pretty-show = self.callPackage ./haskell/pretty-show {};
        };

        vstls = self.callPackage ~/Sources/hs-tls/core {};

        monad-network-class = self.callPackage ~/Sources/monad-network-class {};
        monad-network-instances = self.callPackage ~/Sources/monad-network-instances {};
        conduit-http-connection = self.callPackage ~/Sources/conduit-http-connection {};
        si = self.callPackage ~/Sources/si {};
        console-program = self.callPackage ./haskell/console-program {};
        cloud = self.callPackage ~/Sources/cloud { };
        cloud-common = self.callPackage ~/Sources/cloud-common { };
        cloud-dropbox = self.callPackage ~/Sources/cloud-dropbox { };
        cloud-googledrive = self.callPackage ~/Sources/cloud-googledrive { };
        cloud-sync = self.callPackage ~/Sources/cloud-sync { };
      };
    };
  };
}
