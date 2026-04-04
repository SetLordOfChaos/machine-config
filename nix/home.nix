{ config, pkgs, ... }:

{
  home.username = "set";
  home.homeDirectory = "/home/set";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Important for Ubuntu / non-NixOS
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    git
    curl
    wget
    ripgrep
    fd
    fzf
    jq
    bat
    eza
    tree
    unzip
    zip
    htop
    vscode
    tmux
    starship
    zoxide
  ];

  programs.git = {
    enable = true;
  };

  programs.git.settings = {
    user.name = "set";
    user.email = "setlordchaos@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -lah";
      gs = "git status";
      v = "code";
    };
  };

  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.zoxide.enable = true;

  home.sessionVariables = {
    EDITOR = "code --wait";
  };

  imports = [
    ./../modules/apps/obsidian.nix
  ];
}
