{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono";
      size = 11;
    };
    themeFile = "zenbones_dark";
  };

}
