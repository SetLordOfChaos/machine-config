{ pkgs, ... }:

let
  obsidian = pkgs.appimageTools.wrapType2 {
    name = "obsidian";

    src = pkgs.fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.7/Obsidian-1.12.7.AppImage";
      sha256 = "sha256:f6d8b96fe685a8632c819cc093a248ace0f6bab410f44a6c929a2611b1ebb17c";
    };
  };
in
{
  home.packages = [
    obsidian
  ];
}