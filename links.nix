{ config, pkgs, ... }: {
  xdg.configFile."nvim".source = ./nvim;
  xdg.configFile."sway".source = ./sway;
  xdg.configFile."waybar".source = ./waybar;

programs.neovim={
enable=true;
}
}

