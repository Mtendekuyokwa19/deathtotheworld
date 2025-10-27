{ config, pkgs, ... }: {

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deathtotheworld";
  home.homeDirectory = "/home/deathtotheworld";
  imports = [ ./links.nix ./sh.nix ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.google-chrome
    pkgs.hello
    pkgs.waybar
    pkgs.zathura
    pkgs.jujutsu
    pkgs.python3
    pkgs.niri
    pkgs.calibre
    pkgs.flutter
    pkgs.swaybg
    pkgs.aria2
    pkgs.unityhub
    pkgs.swww
    pkgs.zed-editor
    pkgs.brightnessctl
    pkgs.wlsunset
    pkgs.kitty
    pkgs.nushell
    pkgs.zsh
  ];

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
  programs.zsh.enable = true;

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
  programs.zsh = {
    oh-my-zsh = { # "ohMyZsh" without Home Manager
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };

  programs.neovim = { enable = true; };
  programs.zathura = {
    enable = true;
    options = {
      font = "JetBrainsMono Nerd Font 11";
      window-title-basename = true;
      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = 1;
      scroll-page-aware = true;
      scroll-full-overlap = 1.0e-2; # Fixed decimal format
      scroll-step = 50;
      zoom-min = 10;
      guioptions = "none";

      # Zenbones Dark Colors
      notification-error-bg = "#191919";
      notification-error-fg = "#de6e7c";
      notification-warning-bg = "#191919";
      notification-warning-fg = "#d68c67";
      notification-bg = "#191919";
      notification-fg = "#b7c5d3";

      completion-bg = "#2c2c2c";
      completion-fg = "#b7c5d3";
      completion-group-bg = "#191919";
      completion-group-fg = "#819b69";
      completion-highlight-bg = "#6099c0";
      completion-highlight-fg = "#191919";

      index-bg = "#191919";
      index-fg = "#b7c5d3";
      index-active-bg = "#6099c0";
      index-active-fg = "#191919";

      inputbar-bg = "#2c2c2c";
      inputbar-fg = "#b7c5d3";

      statusbar-bg = "#2c2c2c";
      statusbar-fg = "#b7c5d3";

      highlight-color = "#d68c67";
      highlight-active-color = "#819b69";

      default-bg = "#191919";
      default-fg = "#b7c5d3";
      render-loading = true;
      render-loading-bg = "#191919";
      render-loading-fg = "#b7c5d3";

      recolor-lightcolor = "#191919";
      recolor-darkcolor = "#b7c5d3";
      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;

      smooth-scroll = true;
    };
  };
  services.swww.enable = true;
  # Waybar configuration - SIMPLIFIED VERSION
  programs.waybar = {
    enable = false;
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
