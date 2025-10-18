{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono";
      size = 11;
    };
    extraConfig = ''
            cursor_trail 3
      cursor_trail_decay 0.1 0.4
    '';
    themeFile = "zenbones_dark";
  };

  programs.neovim = { enable = true; };
}
