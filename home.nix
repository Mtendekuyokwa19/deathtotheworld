{ config, pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mtende";
  home.homeDirectory = "/home/mtende";
  imports = [ ./links.nix ./sh.nix ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    [ pkgs.hello pkgs.waybar pkgs.jujutsu pkgs.niri pkgs.kitty pkgs.oh-my-zsh ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # You can add dotfiles here if needed
  };

  # Session variables - FIXED VERSION
  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "sway";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    EDITOR = "vim";
    # Disable portal requirement for testing
    XDG_DESKTOP_PORTAL_FORCE_BACKEND = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Sway configuration - FIXED VERSION
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
    };
    extraConfig = ''
      exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      exec systemctl --user import-environment
    '';
  };

  # Waybar configuration - SIMPLIFIED VERSION
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [ "eDP-1" "HDMI-A-1" ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "battery" "clock" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        clock = {
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = "{:%Y-%m-%d}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };

  # Services that need to be enabled
  services.mako.enable = true;
}
