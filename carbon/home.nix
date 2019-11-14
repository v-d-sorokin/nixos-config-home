{pkgs}:
{
  programs.urxvt = {
    fonts = [ "xft:Dejavu Sans Mono:pixelsize=30" ];
  };

  services = {
    network-manager-applet = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    xlibs.xbacklight
  ];
}
