{ pkgs }:
{
  packageOverrides = super: let selfp = super.pkgs; in
  {
    syncthing = super.callPackage ./syncthing {};
    haskellPackages = super.haskellPackages.override {
      overrides = self: super: {
        cryptonite = self.cryptonite_0_24;
        tls = self.callPackage /home/vs/Syncthing/Sources/hs-tls/core {};
        monad-network-class = self.callPackage /home/vs/Syncthing/Sources/monad-network-class {};
        monad-network-instances = self.callPackage /home/vs/Syncthing/Sources/monad-network-instances {};
        conduit-http-connection = self.callPackage /home/vs/Syncthing/Sources/conduit-http-connection {};
        si = self.callPackage /home/vs/Syncthing/Sources/si {};
        console-program = self.callPackage /home/vs/Syncthing/Sources/console-program {};
        cloud = self.callPackage /home/vs/Syncthing/Sources/cloud {};
        cloud-sync = self.callPackage /home/vs/Syncthing/Sources/cloud-sync {};
        taffybar = self.callPackage /home/vs/Syncthing/Sources/taffybar {};
      };
    };
  };
}
