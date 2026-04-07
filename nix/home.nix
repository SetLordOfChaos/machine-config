{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "set";
    homeDirectory = "/home/set";
    stateVersion = "25.05";
  };

  # Important for Ubuntu / non-NixOS
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    git
    curl
    wget
    shellcheck
    alejandra
    statix
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
    tmux
    starship
    zoxide
  ];

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = "set";
        user.email = "setlordchaos@gmail.com";
      };
    };
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
    ./../modules/apps/vscode.nix
  ];
}
