{ pkgs }:
{
  permittedInsecurePackages = [
    "evilvte-0.5.2-20140827"
  ];
  allowBroken = true;
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
  in {
    evilvte = super1.evilvte.override {
       configH = ''
#define SCROLL_LINES 100000
#define MATCH_STRING_L "firefox"
'' ;
       };

    sopcast = super1.callPackage ./sopcast {};
    sopcast-cli = super1.callPackage ./sopcast-cli {};
    coolreader = super1.callPackage ./coolreader {};
    acestream-player = super1.callPackage ./acestream-player {};

    haskellPackages = super1.haskellPackages.override {
      overrides = self: super: rec {
        cabal-helper = self.callPackage ./haskell/cabal-helper {
          cabal-plan = self.callPackage ./haskell/cabal-plan {};
          pretty-show = self.callPackage ./haskell/pretty-show {};
        };

        vstls = self.callPackage /home/vs/Syncthing/Sources/hs-tls/core {};

        monad-network-class = self.callPackage /home/vs/Syncthing/Sources/monad-network-class {};
        monad-network-instances = self.callPackage /home/vs/Syncthing/Sources/monad-network-instances {};
        conduit-http-connection = self.callPackage /home/vs/Syncthing/Sources/conduit-http-connection {};
        si = self.callPackage /home/vs/Syncthing/Sources/si {};
        console-program = self.callPackage ./haskell/console-program {};
#        gi-notify = self.callPackage ./haskell/gi-notify {};
#        gi-gdkpixbuf = self.callPackage ./haskell/gi-gdkpixbuf {};
#        gi-gio = self.callPackage ./haskell/gi-gio {};
#        gi-glib = self.callPackage ./haskell/gi-glib {};
#        gi-gobject = self.callPackage ./haskell/gi-gobject {};
#        gi-cairo = self.callPackage ./haskell/gi-cairo { inherit (super1) cairo; };
#        gi-atk = self.callPackage ./haskell/gi-atk {};
#        gi-cairo-render = self.callPackage ./haskell/gi-cairo-render { inherit (super1) cairo; };
#        gi-dbusmenu = self.callPackage ./haskell/gi-dbusmenu {};
#        gi-pango = self.callPackage ./haskell/gi-pango { inherit (super1) cairo pango; };
#        gi-xlib = self.callPackage ./haskell/gi-xlib {};
#        gi-gdk = self.callPackage ./haskell/gi-gdk { inherit (super1) gtk3; };
#        gi-gdkx11 = self.callPackage ./haskell/gi-gdkx11 { inherit (super1) gtk3; };
#        gi-gtk = self.callPackage ./haskell/gi-gtk { inherit (super1) gtk3; };
#        gi-gtk-hs = self.callPackage ./haskell/gi-gtk-hs { };
#        gi-dbusmenugtk3 = self.callPackage ./haskell/gi-dbusmenugtk3 { inherit (super1) gtk3; };
#        haskell-gi = self.callPackage ./haskell/haskell-gi {};
#        haskell-gi-base = super1.haskell.lib.addBuildDepend (self.callPackage ./haskell/haskell-gi-base {}) super1.gobject-introspection;
#        broadcast-chan = self.callPackage ./haskell/broadcast-chan { };
#        taffybar = self.callPackage ./haskell/taffybar { inherit (super1) gtk3; };
        cloud = self.callPackage /home/vs/Syncthing/Sources/cloud { };
        cloud-common = self.callPackage /home/vs/Syncthing/Sources/cloud-common { };
        cloud-dropbox = self.callPackage /home/vs/Syncthing/Sources/cloud-dropbox { };
        cloud-googledrive = self.callPackage /home/vs/Syncthing/Sources/cloud-googledrive { };
        cloud-sync = self.callPackage /home/vs/Syncthing/Sources/cloud-sync { };
      };
    };
  };
}
