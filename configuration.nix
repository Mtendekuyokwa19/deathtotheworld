# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

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
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Blantyre";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.mtende = {
    isNormalUser = true;
    description = "Mtende";
    shell = pkgs.nushell;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc6CqhLnw+gZs3/tW0Rb5wCnu3UllyJ4OZ5qUuxunAw mtendekuyokwa19@gmail.com"
    ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  users.defaultUserShell = pkgs.nushell;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.niri.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    godot
    nushell
    exiftool
    wget
    swaybg
    swww
    neovim
    ffmpeg-full
    ghostty
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
    python3
    kitty
    lua
    unzip
    go
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
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako
  ];
  programs.light.enable = true;
  environment.variables.EDITOR = "vim";

  # Enable XDG desktop portals - SIMPLIFIED VERSION (WLR only)
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

  swapDevices = [{
    device = "/swapfile";
    size = 8192;
  }];
  # Ensure dbus is properly configured
  services.dbus.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.05"; # Did you read the comment?
}
