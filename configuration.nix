{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "deathtotheworld"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Blantyre";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # --- AUDIO CONFIG ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  # -------------------

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.mtende = {
    isNormalUser = true;
    description = "Mtende";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "audio" ]; # added "audio"
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc6CqhLnw+gZs3/tW0Rb5wCnu3UllyJ4OZ5qUuxunAw mtendekuyokwa19@gmail.com"
    ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  users.defaultUserShell = pkgs.zsh;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;

  networking.firewall.enable = false;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    ollama
    go
    # Re-enabled after upstream fix
    inputs.noctalia.packages.${"x86_64-linux"}.default
    inputs.quickshell.packages.${
      "x86_64-linux"
    }.default # Keep this commented until quickshell is also fixed
    godot
    nushell
    exiftool
    delta
    wget
    zsh
    swaybg
    swww
    openssl
    neovim
    ffmpeg-full
    arduino
    vscode
    prisma
    prisma-engines
    ghostty
    postgresql
    home-manager
    rustc
    fuzzel
    cargo
    jdk
    brightnessctl
    gcc
    fzf
    typst
    zathura
    spotify
    python3
    pandoc
    kitty
    lua
    unzip
    nodejs
    git
    xfce.thunar
    jujutsu
    ripgrep
    waybar
    sway
    niri
    google-chrome
    neofetch
    rustup
    curl
    postman
    chromium
    zellij
    grim
    slurp
    wl-clipboard
    mako
  ];
  programs.light.enable = true;
  environment.variables.EDITOR = "vim";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config = {
      common = { default = [ "wlr" ]; };
      sway = {
        default = pkgs.lib.mkForce [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screencast" = [ "wlr" ];
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all       all     trust
      host  all       all     127.0.0.1/32   trust
      host  all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };

  swapDevices = [{
    device = "/swapfile";
    size = 8192;
  }];

  services.dbus.enable = true;
  services.ollama = {
    enable = true;
    loadModels = [ "gemma2:2b" ];
  };

  system.stateVersion = "25.05";
}
