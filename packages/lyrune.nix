{ fetchurl, appimageTools, wayland }:

appimageTools.wrapType2 (finalAttrs: {
  pname = "lyrune";
  version = "1.7.4";

  src = fetchurl {
    url = "https://github.com/amtoaer/lyrune/releases/download/v${finalAttrs.version}/lyrune-v${finalAttrs.version}-linux-amd64.AppImage";
    hash = "sha256-ccx/diqJabs9xj0rWJA5OxeDuw83PBiyyBlqolg635Y=";
  };

  # The bundled Wayland client lacks symbols required by current Mesa drivers.
  profile = ''
    export LD_PRELOAD="${wayland}/lib/libwayland-client.so.0''${LD_PRELOAD:+:$LD_PRELOAD}"
  '';

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/usr/share/applications/lyrune.desktop \
      $out/share/applications/lyrune.desktop
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "Linux QQ Music desktop client";
    homepage = "https://github.com/amtoaer/lyrune";
    platforms = [ "x86_64-linux" ];
    mainProgram = "lyrune";
  };
})
