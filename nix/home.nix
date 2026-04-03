{ config, pkgs, ... }:

{
  home.username = "set";
  home.homeDirectory = "/home/set";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home-manager.backupFileExtension = "backup-before-nix";

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
    neovim
    tmux
    starship
    zoxide
  ];

  programs.git = {
    enable = true;
  };

  programs.git.extraConfig = {
    user.name = "Set";
    user.email = "setlordchaos@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -lah";
      gs = "git status";
      v = "nvim";
    };
  };

  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.zoxide.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
