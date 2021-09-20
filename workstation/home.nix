{pkgs}:
{
  programs.urxvt = {
    fonts = [ "xft:Terminess Powerline:size=22" ];
  };
  xsession = {
    enable = true;
    pointerCursor = {
      size = 32;
    };

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
  services = {
    network-manager-applet = {
      enable = true;
    };
#    picom = {
#      enable = true;
#      backend = "glx";
#      vSync = true;
#    };
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
  };

  home.packages = with pkgs; [
    notify-osd
    ufoai
  ];

  home.file = {
    ".config/taffybar/taffybar.hs".source = ./taffybar.hs;
    ".config/taffybar/taffybar.css".source = ./taffybar.css;

    ".notify-osd".source = ./notify-osd.conf;
    ".emacs".text = import ../emacs.nix { fontSize = 14; };
  };
}
