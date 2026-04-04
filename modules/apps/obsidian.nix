{ pkgs, ... }:

let
  version = "1.12.7";

  obsidian = pkgs.appimageTools.wrapType2 {
    pname = "obsidian";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage";
      sha256 = "sha256:f6d8b96fe685a8632c819cc093a248ace0f6bab410f44a6c929a2611b1ebb17c";
    };
  };
in
{
  home.packages = [
    obsidian
  ];
}