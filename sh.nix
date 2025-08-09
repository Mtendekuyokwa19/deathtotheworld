{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono";
      size = 11;
    };
    themeFile = "zenbones_dark";
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };
    shellAliases = {

      ll = "ls -l";
      ".." = "cd ..";
    };
  };

}
