{pkgs}:
{
  programs.urxvt = {
    fonts = [ "xft:Terminess Powerline:style=Regular:size=22" ];
    extraConfig = {
      letterspace = "-2";
    };
  };
  programs.ssh = {
    matchBlocks = {
      "workstation.local" = {
        identityFile = "~/.ssh/nix_remote";
      };
    };
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

    initExtra = ''
#      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 144
    '';
  };
  xresources.properties = {
    "Xft.dpi" = 144;
  };
  services = {
    network-manager-applet = {
      enable = true;
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
  };

  home.packages = with pkgs; [
    notify-osd
    brightnessctl
  ];

  home.file = {
    ".config/taffybar/taffybar.hs".source = ./taffybar.hs;
    ".config/taffybar/taffybar.css".source = ./taffybar.css;

    ".notify-osd".source = ./notify-osd.conf;
    ".emacs".text = import ../emacs.nix { fontSize = 14; };
  };
}
