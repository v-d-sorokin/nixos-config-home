{ pkgs }:
{
  permittedInsecurePackages = [
    "evilvte-0.5.2-20140827"
  ];
  allowBroken = true;
  allowUnfree = true;

  packageOverrides = super1:
  let
    haskellPackages2 = super1.haskellPackages.override {
      overrides = self: super: rec {
        vstls = self.callPackage /home/vs/Syncthing/Sources/hs-tls/core {};

        monad-network-class = self.callPackage /home/vs/Syncthing/Sources/monad-network-class {};
        monad-network-instances = self.callPackage /home/vs/Syncthing/Sources/monad-network-instances {};
        conduit-http-connection = self.callPackage /home/vs/Syncthing/Sources/conduit-http-connection {};
        si = self.callPackage /home/vs/Syncthing/Sources/si {};
        console-program = self.callPackage /home/vs/Syncthing/Sources/console-program {};
        cloud = self.callPackage /home/vs/Syncthing/Sources/cloud {};
        cloud-sync = self.callPackage /home/vs/Syncthing/Sources/cloud-sync {};
      };
    };
  in {
#    home-manager = (import /home/vs/Syncthing/Sources/home-manager {}).home-manager;
    evilvte = super1.evilvte.override {
       configH = ''
#define SCROLL_LINES 100000
#define MATCH_STRING_L "firefox"
'' ;
       };

    sopcast = super1.callPackage ./sopcast {};
    sopcast-cli = super1.callPackage ./sopcast-cli {};
    coolreader = super1.callPackage ./coolreader {};

    haskellPackages = super1.haskellPackages.override {
      overrides = self: super: rec {

        inherit (haskellPackages2) vstls monad-network-class monad-network-instances conduit-http-connection
          si console-program cloud cloud-sync;
      };
    };
  };
}
