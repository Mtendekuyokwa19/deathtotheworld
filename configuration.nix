{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelModules = [ "kvm-intel" ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  # Bootloader - Fixed for UEFI systems
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev"; # Changed from "/dev/sda"
      efiSupport = true; # Added for UEFI
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true; # Added for UEFI
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;
  # Enhanced Bluetooth Configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
  services.blueman.enable = true;

  time.timeZone = "Africa/Blantyre";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.adb.enable = true;
  programs.nix-ld.enable = true;
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

  users.users.deathtotheworld = {
    isNormalUser = true;
    description = "Mtende";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "bluetooth"
      "libvirtd"
      "kvm"
    ]; # added "bluetooth"
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
    aria2
    exiftool
    delta
    android-studio
    yazi
    android-tools
    wget
    helix
    openjdk
    zsh
    swaybg
    swww
    openssl
    ed
    ffmpeg-full
    arduino
    vscode
    feh
    genymotion
    prisma
    i3
    dmenu
    prisma-engines
    ghostty
    postgresql
    home-manager
    obsidian
    rustc
    neovim
    yarn
    qtspim
    fuzzel
    cargo
    jdk
    brightnessctl
    gcc
    steam
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
    ngrok
    ripgrep
    waybar
    sway
    sqlite
    sqlitestudio
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
    # Bluetooth packages
    bluez
    bluez-tools
  ];

  programs.light.enable = true;
  environment.variables.EDITOR = "vim";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

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
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
    };
  };

}
