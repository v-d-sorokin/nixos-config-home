{ pkgs, lib, ... }:

with lib;

let
  unstable = import <unstable> {};

  spinner-file = "spinner-1.7.3.el";
  spinner-lzip = builtins.fetchurl {
    url = "https://elpa.gnu.org/packages/${spinner-file}.lz";
    sha256 = "188i2r7ixva78qd99ksyh3jagnijpvzzjvvx37n57x8nkp8jc4i4";
  };
  emacsOverrides = self: super: rec {
    spinner = super.spinner.override {
      elpaBuild = args: super.elpaBuild (args // {
        src = pkgs.runCommandLocal spinner-file {} ''
          ${pkgs.lzip}/bin/lzip -d -c ${spinner-lzip} >$out
        '';
      });
    };
  };
  emacs = ((pkgs.emacsPackagesGen pkgs.emacs).overrideScope' emacsOverrides).emacsWithPackages(epkgs: with epkgs; [
#    all-the-icons
#    auctex
    coffee-mode
    company
    company-box
    counsel
    counsel-gtags
    counsel-projectile
    cmm-mode
    dante
    direnv
    dhall-mode
    doom-modeline
    doom-themes
    elm-mode
    engine-mode
    expand-region
    fira-code-mode
    flx
    flycheck
    forge
    flycheck-elm
    flycheck-haskell
    glsl-mode
    ggtags
#    ghc
    haml-mode
    haskell-mode
    haskell-snippets
    hasky-extensions
    helm
    helm-gtags
    helm-hoogle
#    hindent
    hlint-refactor
    ivy
    ivy-hydra
    js2-mode
    lua-mode
    lsp-ivy
    lsp-haskell
    lsp-mode
    lsp-treemacs
    lsp-ui
    markdown-mode
    magit
    nix-mode
    org-drill
    org-plus-contrib
    org-roam
    epkgs.ormolu
    pkg-info
    projectile
    rainbow-delimiters
    rspec-mode
    rust-mode
    smartparens
    spacemacs-theme
    swiper
    typescript-mode
    undo-tree
    use-package
    unicode-fonts
    vterm
    which-key
    yaml-mode
    ]);

  torbrowser_custom = unstable.torbrowser.override { pulseaudioSupport = true; };

  hostname = readFile /etc/nixos/hostname;

  #myide = (import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {}).ghcide-ghc865;
  myide = (import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {}).selection { selector = p: { inherit (p) ghc882; }; };
in
mkMerge [(import ((toString ./.) + "/${hostname}/home.nix") { inherit pkgs; })
({
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixFlakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')

    fwupd
    nvme-cli

    audacious
    htop
    iotop
    atop
    niv
    nix-top
    nixfmt
    nixpkgs-fmt
    nix-diff
    nixpkgs-lint
    nix-linter
    nix-template
    nixos-shell
    fortune
    libnotify
    pasystray
    conky
    rxvt_unicode
    gxneur
    libreoffice
    gnome3.nautilus
    chromium
    tree
    hicolor-icon-theme
    gnome3.adwaita-icon-theme
    gnome3.networkmanagerapplet
#    sopcast-cli
    coolreader
    fbreader
    at-spi2-core
    lynx
    ctags
    tmux
    plantuml
    gwenview
    dia
    dropbox-cli
    gparted
    gnome3.gnome-disk-utility

    ccls
#    pythonPackages.python-language-server
    python2
    python3

    gdb
    minicom

    ghc
    cachix
    linuxPackages.cpupower
    pwgen
    cdrtools
    rpm
    emacs
    emacs-all-the-icons-fonts

    smplayer
#    transmission
#    transmission-gtk
    qbittorrent

#    acestream-player

#    myide
    gnumake
    binutils
    strace
    ltrace
    lsof
    direnv
    gnome3.gnome-terminal
    curl
    evince
    file
    unrar
    p7zip
    unzip
    wineWowPackages.stable
    winetricks
    pavucontrol
    kodi
    gnome3.gnome-mines
    youtube-dl

    virt-manager
    thunderbird
    pidgin
    nheko

    torbrowser_custom
  ] ++ (with pkgs.haskellPackages; [
#    si
#    taffybar
#    apply-refact
#    hlint
#    hindent
#    stylish-haskell
#    structured-haskell-mode
#    hoogle-index
#    hasktags
#    hoogle
    cabal-install
    cabal2nix
  ]) ++ (with pkgs.linuxPackages; [
#    turbostat
  ]);

  manual = {
    html.enable = false;
    manpages.enable = false;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/x-zip-compressed-fb2" = "cr3.desktop";
        "application/x-fictionbook+xml" = "cr3.desktop";

        "video/mp4" = "mpv.desktop";
        "video/mp4v" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/x-avi" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-mpeg" = "mpv.desktop";

        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
      associations.added = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = false;
      theme = "powerlevel9k";
      plugins = [ "git" "cabal" "docker" "git-extras" "python" "sudo" "systemd" "tmux" "powerline"
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
            sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
          };
        }
      ];
    };
    initExtra = ''
      source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme

      eval "$(direnv hook zsh)"

      export PATH=$PATH:~/.local/bin
      export BROWSER=firefox
      export DIRENV_ALLOW_NIX=1

      alias vi="vim"
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
#      bell-command = "notify-send \"urxvt: bell\"";
      cursorBlink = "0";
      cursorUnderline = "1";
    };
  };

  programs.jq = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
#    extensions = with pkgs.nur.repos.rycee.firefox-addons; [];
  };

  programs.emacs = {
    enable = false;
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
    matchBlocks = {
      "*office.numatech.ru" = {
        hostname = "gitlab.office.numatech.ru";
        identityFile = "/home/vs/.ssh/numa-id_rsa";
      };
      "*" = {
        identityFile = [ "~/.ssh/id_rsa" "~/.ssh/numa-id_rsa" ];
      };
    };
  };
#  programs.neovim = {
#    enable = true;
#  };
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
      vim-mucomplete
    ];

    extraConfig = ''
      set completeopt+=menuone
      set completeopt+=noselect
      set shortmess+=c   " Shut off completion messages
      set belloff+=ctrlg " If Vim beeps during completion

      let g:mucomplete#enable_auto_at_startup = 1
      let g:mucomplete#completion_delay = 1

      let g:LanguageClient_serverCommands = { 'haskell': ['haskell-language-server'] }
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
    dropbox = {
      enable = false;
    };
    blueman-applet = {
      enable = true;
    };
    lorri.enable = true;
    polybar = {
      enable = false;
      config = {};
      script = "polybar bar &";
    };
    pasystray = {
#      enable = true;
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
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  xsession = {
    pointerCursor = {
      package = pkgs.oxygen;
      name = "Oxygen_Black";
      defaultCursor = "left_ptr";
    };
    initExtra = ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -model pc105 -layout us,ru -option grp:lalt_lshift_toggle
    '';
    preferStatusNotifierItems = true;
  };
  xresources = {
  };
  gtk = {
    enable = true;
    font = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans 12";
    };
    iconTheme = {
#      package = pkgs.gnome3.adwaita-icon-theme; #pkgs.hicolor_icon_theme;
      name = "hicolor";
    };
  };

  systemd.user.services = {
    mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [ "network.target" "sound.target" ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "hm-graphical-session.target" ];
    };
    dropbox = {
      Unit.Description = "Dropbox";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Environment = [
          ("QT_PLUGIN_PATH=/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix)
          ("QML2_IMPORT_PATH=/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix)
        ];
        ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
        ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
        KillMode = "control-group"; # upstream recommends process
        Restart = "on-failure";
        PrivateTmp = true;
        ProtectSystem = "full";
        Nice = 10;
      };
    };
  };

  home.file = {
    ".xxkbrc".source = ./xxkbrc;
    ".Xmodmap".source = toString ./. + "/${hostname}/Xmodmap";

#    ".spacemacs".source = ./spacemacs;

    ".lynxrc".source = ./lynxrc;
  };
})]
