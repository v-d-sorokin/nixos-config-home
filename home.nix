{ pkgs, lib, ... }:

with lib;

let

  spacemacs = pkgs.fetchFromGitHub {
    owner = "syl20bnr";
    repo = "spacemacs";
    rev = "22d200fbabfea2ac1771fbd4657c395cd5331194";
    sha256 = "13yrv5j8lan19kg532x5q8rg4hqqm8d5h22dwz9hg9j43hhsq500";
    postFetch = ''
      mkdir -p $out
      tar xf $downloadedFile --strip=1 --directory=$out
      mkdir -p $out/.cache
    '';
  };

  hostname = readFile /etc/nixos/hostname;

  myide = (import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {}).ghcide-ghc865;
  #myide = (import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {}).selection { selector = p: { inherit (p) ghc865; }; };
in
mkMerge [(import ((toString ./.) + "/${hostname}/home.nix") { inherit pkgs; })
({
  home.packages = with pkgs; [
    htop
    iotop
    atop
    fortune
    libnotify
    notify-osd
    pasystray
    conky
    rxvt_unicode
    gxneur
    libreoffice
    gnome3.nautilus
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
    python2

    ghc
    cachix
    linuxPackages.cpupower
    pwgen

    smplayer
    transmission

    acestream-player

    myide
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

  manual = {
    html.enable = true;
    manpages.enable = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "awesomepanda";
      plugins = [ "git" "cabal" "docker" "git-extras" "python" "sudo" "systemd" "tmux" ];
    };
    initExtra = ''
      printf '\033[5 q\r'
    '';
  };

  programs.urxvt = {
    enable = true;
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };

    extraConfig = {
      background = "#8888A0";
      bell-command = "notify-send \"urxvt: bell\"";
      cursorBlink = "0";
      cursorUnderline = "1";
    };
  };

  programs.jq = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
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
      package = pkgs.gnome3.adwaita-icon-theme; #pkgs.hicolor_icon_theme;
      name = "Adwaita";
    };
  };

  systemd.user.services = {
    dropbox = {
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.dropbox}/bin/dropbox start";
        Restart = "always";
      };
    };
  };

  home.file = {
    ".config/taffybar/taffybar.hs".source = toString ./. + "/${hostname}/taffybar.hs";
    ".config/taffybar/taffybar.css".source = toString ./. + "/${hostname}/taffybar.css";

    ".notify-osd".source = ./notify-osd.conf;
    ".xxkbrc".source = ./xxkbrc;
    ".Xmodmap".source = toString ./. + "/${hostname}/Xmodmap";

    ".spacemacs".source = ./spacemacs;

    ".lynxrc".source = ./lynxrc;
  };
})]
