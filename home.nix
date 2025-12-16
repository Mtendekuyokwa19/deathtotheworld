{ config, pkgs, inputs, ... }:

let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deathtotheworld";
  home.homeDirectory = "/home/deathtotheworld";
  imports = [ ./links.nix ./sh.nix ];

  home.stateVersion = "25.05";

  home.sessionVariables = {
    PKG_CONFIG_PATH =
      "${pkgs.libsecret.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig";
    # Prisma engine paths for NixOS compatibility
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";
    PRISMA_QUERY_ENGINE_LIBRARY = "/nix/store/w6lhwd7ailwb2fgibm250cqk8z88ylsn-prisma-engines-6.18.0/lib/libquery_engine.node";
    PRISMA_QUERY_ENGINE_BINARY = "/nix/store/w6lhwd7ailwb2fgibm250cqk8z88ylsn-prisma-engines-6.18.0/bin/query-engine";
    PRISMA_SCHEMA_ENGINE_BINARY = "/nix/store/w6lhwd7ailwb2fgibm250cqk8z88ylsn-prisma-engines-6.18.0/bin/schema-engine";
  };

  # Add local bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = with pkgs; [
    google-chrome
    hello
    waybar
    zathura
    unstable.jujutsu # Using unstable jujutsu
    unstable.prisma # Using unstable Prisma (6.18.0)
    python3
    unzip
    niri
    fzf
    calibre
    unstable.flutter # Using unstable Flutter
    unstable.zed-editor # Using unstable Flutter
    swaybg
    aria2
    unityhub
    swww
    globalprotect-openconnect
    brightnessctl
    wlsunset
    kitty
    nushell
    dwm
    zsh
  ];

  

  # Rest of your configuration remains the same...
  home.file = { };

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
      scroll-full-overlap = 1.0e-2;
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
