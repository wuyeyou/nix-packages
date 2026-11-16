{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 (finalAttrs: {
  pname = "cherry-studio";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/CherryHQ/cherry-studio/releases/download/v${finalAttrs.version}/Cherry-Studio-${finalAttrs.version}-linux-x64.AppImage";
    hash = "sha256-qv0XMc1qqpnMzi9bgzP7BuFPKpt8A6RsPNVvB/OnQBs=";
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/CherryStudio.desktop $out/share/applications/CherryStudio.desktop
    substituteInPlace $out/share/applications/CherryStudio.desktop \
      --replace-fail 'Exec=AppRun %U' 'Exec=cherry-studio %U'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "Desktop client for multiple AI providers";
    homepage = "https://github.com/CherryHQ/cherry-studio";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cherry-studio";
  };
})
