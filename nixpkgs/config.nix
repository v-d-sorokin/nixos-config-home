{ pkgs }:
{
  allowUnfree = true;
  allowBroken = true;
#  binaryCaches = [
#    "https://cachix.cachix.org"
#    "https://all-hies.cachix.org"
#  ];
#  binaryCachePublicKeys = [
#    "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
#    "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
#  ];
   permittedInsecurePackages = [
         "p7zip-16.02"
   ];


  packageOverrides = super1:
  let
    sources = ~/Sources;
  in rec {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    winetricks = super1.winetricks.override { wine = super1.wineWowPackages.stable; };
    ufoai = super1.callPackage ./ufoai {};

    libGLU_combined = super1.buildEnv {
      name = "libGLU-combined";
      paths = [ super1.libGL super1.libGLU ];
      extraOutputsToInstall = [ "dev" ];
    };

#    kodi = super1.kodi.overrideAttrs(attrs: {
#      buildInputs = attrs.buildInputs ++ [ super1.xorg.xrandr ];
#    });

    sopcast = super1.callPackage ./sopcast {};
    sopcast-cli = super1.callPackage ./sopcast-cli {};
    acestream-player = super1.callPackage ./acestream-player {};
    acestream-engine = super1.callPackage ./acestream-engine {};

    inherit (haskellPackages) ghc;

    haskellPackages = super1.haskellPackages.override {
      overrides = self: super: rec {
        vstls = self.callPackage ~/Sources/hs-tls/core {};

        monad-network-class = self.callPackage ~/Sources/monad-network-class {};
        monad-network-tcp = self.callPackage ~/Sources/monad-network-tcp {};
        monad-network-tls = self.callPackage ~/Sources/monad-network-tls {};
#        monad-network-instances = self.callPackage ~/Sources/monad-network-instances {};
        conduit-http-connection = self.callPackage ~/Sources/conduit-http-connection {};
        si = self.callPackage ~/Sources/si {};
        console-program = self.callPackage ./haskell/console-program {};
        cloud = self.callPackage ~/Sources/cloud { };
        cloud-common = self.callPackage ~/Sources/cloud-common { };
        cloud-dropbox = self.callPackage ~/Sources/cloud-dropbox { };
        cloud-googledrive = self.callPackage ~/Sources/cloud-googledrive { };
        cloud-sync = self.callPackage ~/Sources/cloud-sync { };
        base32-z-bytestring = pkgs.haskell.lib.dontCheck super.base32-z-bytestring;
      };
    };
  };
}
