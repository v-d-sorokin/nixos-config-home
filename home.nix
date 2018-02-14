{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fortune
    pkgs.haskellPackages.si
    pkgs.haskellPackages.taffybar
    pkgs.haskellPackages.xmobar
  ];
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
      epkgs.use-package
      epkgs.dante
      epkgs.flycheck-color-mode-line
      epkgs.flycheck-pos-tip
      epkgs.flymake-hlint
      epkgs.flycheck-haskell
      # epkgs.zerodark-theme
      epkgs.undo-tree
      epkgs.idris-mode
      epkgs.haskell-mode
      epkgs.company
      epkgs.company-ghc
      epkgs.company-dict
      epkgs.company-cabal
    ];
  };
  programs.git = {
    enable = true;
    userName = "Vladimir Sorokin";
    userEmail = "v.d.sorokin@gmail.com";
  };

  services = {
    random-background = {
      enable = true;
      imageDirectory = "%h/Dropbox/Photos/Backgrounds";
      interval = "*:0/30";
    };
    udiskie = {
      enable = true;
    };
    syncthing = {
      enable = true;
      tray = true;
    };
    network-manager-applet = {
      enable = true;
    };
  };
  xsession = {
    enable = true;
    #pointerCursor = { package = ""; name = ""; size = 64; };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [ 
          haskellPackages.taffybar
        ];
      };
  };
}
