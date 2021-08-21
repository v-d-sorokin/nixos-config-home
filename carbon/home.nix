{pkgs}:
{
  programs = {
    emacs = {
      # package = pkgs.emacs-pgtk;
    };
    alacritty = {
      enable = true;
      settings = {};
    };
    waybar = {
      enable = true;
      systemd.enable = true;

      settings = [{
        layer = "top";
        position = "top";

        modules-center = [ "sway/window" ];
          modules-left = [ "sway/workspaces" "sway/mode" "tray" ];
          modules-right = [ "pulseaudio" "cpu" "memory" "temperature" "clock" "battery" ];

        modules = {
          battery = {
            format = "{icon} {capacity}% {time}";
            format-charging = "{icon}  {capacity}%";
            format-icons = [ "" "" "" "" "" ];
            interval = 10;
            states = {
              critical = 20;
              warning = 30;
            };
          };
          clock = {
            format = "{:%a %Y-%m-%d %H:%M:%S}";
            interval = 1;
          };
          cpu = { format = " {}%"; };
          memory = { format = " {}%"; };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-icons = [ "" "" ];
            format-muted = "";
          };
          "sway/workspaces" = {
            all-outputs = true;
            disable-scroll = true;
          };
          temperature = {
            critical-threshold = 90;
            format = "{icon} {temperatureC}°C";
            format-icons = [ "" "" "" "" "" ];
            hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            interval = 1;
          };
        };
      } ];
    };
    mako = {
      enable = true;
      defaultTimeout = 10000;
      ignoreTimeout = false;
      font = "Source Code Pro 10";
    };
  };

  services = {
    network-manager-applet = {
      enable = true;
    };
    kanshi = {
      enable = true;
    };

  };

  wayland = {
    windowManager = {
      sway =
        let
          modifier = "Mod4";
          terminal = "alacritty";
          menu = "wofi --show drun";
          kc = import ./keycodes.nix;
          wallpaperCmd = "find ~/Dropbox/Photos/Backgrounds/* | shuf -n 1";
          lockCmd = "swaylock -f -i \`${wallpaperCmd}\` -s fill --indicator --clock";
          script = pkgs.writeScript "laptop.sh" ''
            #! ${pkgs.stdenv.shell} -e
            if grep -q open /proc/acpi/button/lid/LID/state; then
              swaymsg output eDP-1 enable
            else
              swaymsg output eDP-1 disable
            fi
          '';
        in {
        enable = true;
        wrapperFeatures.gtk = true;
        config = {
          inherit modifier terminal menu;
          input."*" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:alt_shift_toggle";
          };
#         input."SynPS/2 Synaptics TouchPad" = {
         input."type:touchpad" = {
            scroll_method = "two_finger";
            dwt = "enabled";
            tap = "enabled";
#            natural_scroll = "enabled";
          };
          output."*" = {
            scale = "2";
            bg = "\`${wallpaperCmd}\` fill";
          };
          output."HDMI-A-2" = {
            resolution = "3840x1600";
          };
          window = {
            hideEdgeBorders = "smart";
          };
          startup = [
            { command = ''
               swayidle -w \
                 timeout 900 '${lockCmd}' \
                 timeout 1200 'swaymsg "output * dpms off"' \
                 resume 'swaymsg "output * dpms on"' \
                 before-sleep '${lockCmd}' \
                 lock '${lockCmd}' 
              '';
            }
            { command = "systemctl --user restart mako"; always = true; }
            { command = "systemctl --user retsart waybar"; always = true; }
          ];
          assigns = {
            "2" = [{ app_id = "Chromium-browser"; }];
            "5" = [{ app_id = "firefox"; }];
            "8" = [{ title = "nheko"; }];
            "9" = [{ app_id = "thunderbird"; }];
          };
          keybindings = {
            "${modifier}+Shift+Return" = "exec ${terminal}";
            "${modifier}+F3" = "exec ${menu}";

            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            "${modifier}+Shift+space" = "floating toggle";
            "${modifier}+Tab" = "focus next";
            "${modifier}+space" = "layout toggle all";
            "${modifier}+Plus" = "fullscreen";

            "${modifier}+1" = "workspace 1";
            "${modifier}+2" = "workspace 2";
            "${modifier}+3" = "workspace 3";
            "${modifier}+4" = "workspace 4";
            "${modifier}+5" = "workspace 5";
            "${modifier}+6" = "workspace 6";
            "${modifier}+7" = "workspace 7";
            "${modifier}+8" = "workspace 8";
            "${modifier}+9" = "workspace 9";
#            "${modifier}+0" = "workspace 10";

            "${modifier}+Shift+1" = "move container to workspace 1";
            "${modifier}+Shift+2" = "move container to workspace 2";
            "${modifier}+Shift+3" = "move container to workspace 3";
            "${modifier}+Shift+4" = "move container to workspace 4";
            "${modifier}+Shift+5" = "move container to workspace 5";
            "${modifier}+Shift+6" = "move container to workspace 6";
            "${modifier}+Shift+7" = "move container to workspace 7";
            "${modifier}+Shift+8" = "move container to workspace 8";
            "${modifier}+Shift+9" = "move container to workspace 9";
            "${modifier}+Shift+0" = "move container to workspace 10";

            "XF86MonBrightnessDown" = "exec brightnessctl set 2%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set 2%+";

            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

          };

          keycodebindings = {
            "${modifier}+Shift+${kc.c}" = "kill";

            "${modifier}+${kc.n}" = "focus left";
            "${modifier}+${kc.t}" = "focus down";
            "${modifier}+${kc.r}" = "focus up";
            "${modifier}+${kc.d}" = "focus right";

            "${modifier}+Shift+${kc.n}" = "move left";
            "${modifier}+Shift+${kc.t}" = "move down";
            "${modifier}+Shift+${kc.r}" = "move up";
            "${modifier}+Shift+${kc.d}" = "move right";

            "${modifier}+${kc.s}" = "split h";
            "${modifier}+${kc.p}" = "split v";
            "${modifier}+${kc.e}" = "fullscreen toggle";

            "${modifier}+${kc.i}" = "layout stacking";
            "${modifier}+${kc.v}" = "layout tabbed";
            "${modifier}+${kc.l}" = "layout toggle split";

            "${modifier}+${kc.q}" = "reload";
            "${modifier}+Shift+${kc.q}" = "exit";

            "${modifier}+${kc.c}" = "mode resize";

            "${modifier}+Shift+${kc.x}" = "exec chromium-browser --enable-features=UseOzonePlatform --ozone-platform=wayland";
            "${modifier}+Shift+${kc.f}" = "exec firefox";

          };
          bars = [];
        };
        extraConfig = ''
          seat seat0 xcursor_theme Oxygen_Black 24

          set $laptop eDP-1
          bindswitch --reload --locked lid:on output $laptop disable
          bindswitch --reload --locked lid:off output $laptop enable
          exec_always ${script}
        '';
        extraSessionCommands = ''
          export MOZ_ENABLE_WAYLAND=1
          export SDL_VIDEODRIVER=wayland
          export QT_QPAPLATFORM=wayland
          export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          export _JAVA_AWT_WM_NONREPARENTING=1
#          export GDK_BACKEND=wayland
        '';
       };
    };
  };

  xsession = {
    pointerCursor = {
      size = 24;
    };
  };

  home.packages = with pkgs; [
    gnome3.gnome-power-manager
    brightnessctl
    qt5.qtwayland

#    swaylock
    swaylock-effects
    swayidle
    wl-clipboard
    wofi
    wdisplays

    oxygen

    nheko
  ];

  home.file = {
    ".emacs".text = import ../emacs.nix { fontSize = 12; };
  };
}
