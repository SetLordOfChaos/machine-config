{
  pkgs,
  lib,
  ...
}: let
  version = "1.12.7";
  pname = "obsidian";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}.AppImage";
    sha256 = "sha256:f6d8b96fe685a8632c819cc093a248ace0f6bab410f44a6c929a2611b1ebb17c";
  };

  extracted = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  obsidian = pkgs.stdenv.mkDerivation {
    inherit pname version;
    dontUnpack = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/share/${pname}
      mkdir -p $out/share/applications
      mkdir -p $out/share/icons/hicolor/512x512/apps

      cp -r ${extracted}/* $out/share/${pname}/

      # Main launcher wrapper
      makeWrapper $out/share/${pname}/obsidian $out/bin/${pname} \
        --add-flags "--no-sandbox" \
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"

      # Desktop launcher
      if [ -f ${extracted}/${pname}.desktop ]; then
        cp ${extracted}/${pname}.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}' \
          --replace 'Icon=${pname}' 'Icon=${pname}'
      else
        printf '%s\n' \
          '[Desktop Entry]' \
          'Name=Obsidian' \
          'Exec=${pname} %U' \
          'Terminal=false' \
          'Type=Application' \
          'Icon=${pname}' \
          'Categories=Office;Utility;' \
          'StartupWMClass=obsidian' \
          > $out/share/applications/${pname}.desktop
      fi

      # Icon
      if [ -f ${extracted}/${pname}.png ]; then
        cp ${extracted}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
      fi

      runHook postInstall
    '';

    meta = with lib; {
      description = "Obsidian AppImage packaged for Home Manager";
      homepage = "https://obsidian.md";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
in {
  home = {
    packages = [
      obsidian
    ];

    file.".local/share/applications/obsidian.desktop".source = "${obsidian}/share/applications/obsidian.desktop";

    file.".local/share/icons/hicolor/512x512/apps/obsidian.png".source = "${obsidian}/share/icons/hicolor/512x512/apps/obsidian.png";
  };
}
