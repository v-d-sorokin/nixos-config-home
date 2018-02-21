{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fortune
    pkgs.haskellPackages.si
    pkgs.haskellPackages.taffybar
    pkgs.haskellPackages.xmobar
    pkgs.libnotify
    pkgs.notify-osd
    pkgs.pasystray
    pkgs.xlibs.xbacklight
    pkgs.conky
    pkgs.evilvte
    pkgs.gxneur
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

  home.file.".emacs.d/haskell-tab-indent.el".text = builtins.readFile ./haskell-tab-indent.el;
  home.file.".emacs.d/init.el".text = builtins.readFile ./emacs.el;

  programs.git = {
    enable = true;
    userName = "Vladimir Sorokin";
    userEmail = "v.d.sorokin@gmail.com";
    aliases = {
      co = "checkout";
    };
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
    taffybar = {
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
      tray = true;
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
    };
    initExtra = ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -model pc105 -layout us,ru -option grp:alt_shift_toggle
      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name  left_ptr
      ${pkgs.pasystray}/bin/pasystray &
      ${pkgs.gxneur}/bin/gxneur &
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
          haskellPackages.taffybar
        ];
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
  home.file.".xmonad/xmonad.hs".text = builtins.readFile ./xmonad.hs;
  home.file.".config/xmobar/xmobarrc".text = builtins.readFile ./xmobarrc;

  home.file.".config/taffybar/taffybar.hs".text = builtins.readFile ./taffybar.hs;
  home.file.".config/taffybar/taffybar.rc".text = builtins.readFile ./taffybar.rc;

  # gconftool-2 -s /apps/notify-osd/gravity --type=int номер
  home.file.".notify-osd".text = builtins.readFile ./notify-osd.conf;
  home.file.".xxkbrc".text = builtins.readFile ./xxkbrc;

  #https://github.com/brndnmtthws/conky
}
