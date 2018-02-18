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
  home.file."emacs.d/home.el".text = builtins.readFile ./emacs.el;
  home.file."emacs.d/haskell-tab-indent.el".text = builtins.readFile ./haskell-tab-indent.el;
  programs.git = {
    enable = true;
    userName = "Vladimir Sorokin";
    userEmail = "v.d.sorokin@gmail.com";
    aliases = {
      co = "checkout";
    };
  };

  services = {
    random-background = {
      enable = true;
      imageDirectory = "%h/Dropbox/Photos/Backgrounds";
      interval = "*:0/30";
    };
    stalonetray = {
      enable = true;
      config = {
        geometry = "3x1-600+0";
        decorations = null;
        icon_size = 30;
        sticky = true;
        background = "#cccccc";
      };
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
        #      config = "xmonad.hs";
    };
  };
  home.file.".xmonad/xmonad.hs".text = builtins.readFile ./xmonad.hs;
  home.file.".config/xmobar/xmobarrc".text = builtins.readFile ./xmobarrc;

  home.file.".config/taffybar/taffybar.hs".text = builtins.readFile ./taffybar.hs;
  home.file.".config/taffybar/taffybar.rc".text = builtins.readFile ./taffybar.rc;
}
