{ pkgs, ... }:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  spacemacs = pkgs.fetchFromGitHub {
    owner = "syl20bnr";
    repo = "spacemacs";
    rev = "3747afb4b02575e794c8e74d1ca9af2fdbd9c525";
    sha256 = "13yrv5j8lan19kg532x5q8rg4hqqm8d5h22dwz9hg9j43hhsq5q8";
    postFetch = ''
      mkdir -p $out
      tar xf $downloadedFile --strip=1 --directory=$out
      mkdir -p $out/.cache
    '';
  };
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
#    evilvte
    rxvt_unicode
    gxneur
    libreoffice
    gnome3.nautilus
#    emacs
    chromium
    tree
    gnome3.adwaita-icon-theme
#    sopcast-cli
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
    python2

    ghc
    cachix
    linuxPackages.cpupower
    pwgen

#    mpv
    smplayer
    transmission

    (all-hies.selection { selector = p: { inherit (p) ghc865; }; })
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
#    cabal-helper
    cabal2nix
  ]);

  manual = {
    html.enable = true;
    manpages.enable = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "cloud";
      plugins = [ "git" "cabal" "docker" "git-extras" "python" "sudo" "systemd" "tmux" ];
    };
  };

  programs.urxvt = {
    enable = true;
    fonts = [ "xft:Dejavu Sans Mono:pixelsize=30" ];
  };

  programs.jq = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      #epkgs.nix-mode
      #epkgs.magit
      #epkgs.use-package
      #epkgs.dante
      #epkgs.flycheck-color-mode-line
      #epkgs.flycheck-pos-tip
      #epkgs.flymake-hlint
      #epkgs.flycheck-haskell
      # epkgs.zerodark-theme
      #epkgs.undo-tree
      #epkgs.idris-mode
      #epkgs.haskell-mode
      #epkgs.company
      #epkgs.company-ghc
      #epkgs.company-dict
      #epkgs.company-cabal
      #epkgs.lsp-mode
      #epkgs.lsp-ui
      #epkgs.lsp-haskell
      #epkgs.company-lsp
    ];
  };

  programs.git = {
    enable = true;
    userName = "Vladimir Sorokin";
    userEmail = "v.d.sorokin@gmail.com";
    aliases = {
      co = "checkout";
    };
  };
  programs.ssh = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
  };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      LanguageClient-neovim
      Syntastic
      ctrlp
      haskell-vim
      hlint-refactor
      haskellconceal
      haskellConcealPlus
      Solarized
      vim-nix
      rainbow
      rainbow_parentheses
      vimproc
    ];

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

  programs.mpv = {
    enable = true;
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
    emacs = {
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

  home.file.".config/taffybar/taffybar.hs".source = ./taffybar.hs;
  home.file.".config/taffybar/taffybar.css".source = ./taffybar.css;

  # gconftool-2 -s /apps/notify-osd/gravity --type=int номер
  home.file.".notify-osd".source = ./notify-osd.conf;
  home.file.".xxkbrc".source = ./xxkbrc;
  home.file.".Xmodmap".source = ./Xmodmap;

  home.file.".spacemacs".source = ./spacemacs;
}
