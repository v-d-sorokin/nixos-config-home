{ pkgs, ... }:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in
{
  home.packages = with pkgs; [
    htop
    fortune
    libnotify
    notify-osd
    pasystray
    xlibs.xbacklight
    conky
    evilvte
    gxneur
    libreoffice
    gnome3.nautilus
    emacs
    chromium
    tree
    gnome3.adwaita-icon-theme
    sopcast-cli
    coolreader
    fbreader
    at-spi2-core
    lynx
    ctags
    tmux
    plantuml
    dropbox

    ccls
    pythonPackages.python-language-server

    #(all-hies.selection { selector = p: { inherit (p) ghc865 ghc864; }; })
  ] ++ (with pkgs.haskellPackages; [
    si
    taffybar
    apply-refact
    hlint
    hindent
    stylish-haskell
    structured-haskell-mode
#    hoogle-index
    hasktags
    hoogle
    cabal-install
    cabal2nix
  ]);
#  programs.home-manager.enable = true;
#  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
#  programs.home-manager.path = "$HOME/Syncthing/Sources/home-manager";

  programs.emacs = {
    enable = false;
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
      epkgs.lsp-mode
      epkgs.lsp-ui
      epkgs.lsp-haskell
      epkgs.company-lsp
    ];
  };

#  home.file.".emacs.d/haskell-tab-indent.el".text = builtins.readFile ./haskell-tab-indent.el;
#  home.file.".emacs.d/init.el".text = builtins.readFile ./emacs.el;

  programs.git = {
    enable = true;
    userName = "Vladimir Sorokin";
    userEmail = "v.d.sorokin@gmail.com";
    aliases = {
      co = "checkout";
    };
  }
  ;
  programs.neovim = {
    enable = true;
  };
  programs.vim = {
    enable = true;
    plugins = [
      "LanguageClient-neovim"
      "Syntastic"
      "ctrlp"
      "haskell-vim"
      "Solarized"
      "vim-nix"
      "rainbow"
      "rainbow_parentheses"
      "vimproc"
    ];
#      set rtp+=~/.vim/pack/TMP/start/LanguageClient-neovim

    extraConfig = ''
      let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }    
      nnoremap <F5> :call LanguageClient_contextMenu()<CR>
      map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
      map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
      map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
      map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
      map <Leader>lb :call LanguageClient#textDocument_references()<CR>
      map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
      map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
    '';
  };

  services = {
    compton = {
      enable = true;
      backend = "glx";
      vSync = "opengl-swc";
    };
    random-background = {
      enable = true;
      imageDirectory = "%h/Dropbox/Photos/Backgrounds";
      interval = "30min";
    };
    status-notifier-watcher = {
      enable = true;
    };
    taffybar = {
      enable = true;
    };
    xembed-sni-proxy = {
      enable = true;
    };
    pasystray = {
      enable = true;
    };
    stalonetray = {
      enable = false;
      config = {
        geometry = "10x1-440+0";
        decorations = null;
        icon_size = 32;
        sticky = true;
        background = "#2d2d2d";
      };
      extraConfig = ''
grow_gravity W
icon_gravity NE
kludges force_icons_size,use_icons_hints
skip_taskbar yes
window_layer top
      '';
    };
    udiskie = {
      enable = true;
    };
    syncthing = {
      enable = true;
      tray = false;
    };
    network-manager-applet = {
      enable = true;
    };
  };
  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.oxygen;
      name = "Oxygen_Black";
      size = 48;
      defaultCursor = "left_ptr";
    };
    initExtra = ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -model pc105 -layout us,ru -option grp:lalt_lshift_toggle
    '';
    preferStatusNotifierItems = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
          haskellPackages.taffybar
        ];

      config = ./xmonad.hs;
#      command = let
#            xmonad = pkgs.xmonad-with-packages.override {
#              packages = self: [ self.xmonad-contrib self.taffybar ];
#            };
#            in
#            ''
#              ${xmonad}/bin/xmonad
#              ${pkgs.pasystray}/bin/pasystray &
#              ${pkgs.gxneur}/bin/gxneur &
#             '';
#      };
    };
  };
  gtk = {
    enable = true;
    font = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans 12";
    };
    iconTheme = {
      package = pkgs.hicolor_icon_theme;
      name = "hicolor";
    };
  };
#  home.file.".xmonad/xmonad.hs".text = builtins.readFile ./xmonad.hs;
#  home.file.".config/xmobar/xmobarrc".text = builtins.readFile ./xmobarrc;

  home.file.".config/taffybar/taffybar.hs".text = builtins.readFile ./taffybar.hs;
  home.file.".config/taffybar/taffybar.css".text = builtins.readFile ./taffybar.css;

  # gconftool-2 -s /apps/notify-osd/gravity --type=int номер
  home.file.".notify-osd".text = builtins.readFile ./notify-osd.conf;
  home.file.".xxkbrc".text = builtins.readFile ./xxkbrc;
  home.file.".Xmodmap".text = builtins.readFile ./Xmodmap;

  #https://github.com/brndnmtthws/conky
}
