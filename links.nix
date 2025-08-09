{ config, pkgs, ... }: {
  xdg.configFile."nvim".source = ./nvim;
  xdg.configFile."waybar".source = ./waybar;
  xdg.configFile."niri".source = ./niri;

  programs.neovim = { enable = true; };
}

