{ config, pkgs, ... }: {
  xdg.configFile."waybar".source = ./waybar;
  xdg.configFile."niri".source = ./niri;
  xdg.configFile."zathura".source = ./zathura;
  xdg.configFile."fuzzel".source = ./fuzzel;
  # xdg.configFile."nvim".source = ./nvim;

}

