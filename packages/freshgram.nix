{ fetchurl, appimageTools }:

appimageTools.wrapType2 (finalAttrs: {
  pname = "freshgram";
  version = "7.6.0";

  src = fetchurl {
    url = "https://github.com/Snowy-Fluffy/freshGram/releases/download/v${finalAttrs.version}/freshGram.AppImage";
    hash = "sha256-Dre39yM9wBIqDkLUiP/exL6Xxgk4haNQYTAFbB9wuz4=";
  };

  profile = ''
    export DESKTOPINTEGRATION=1
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/dbus-1/services
    cp -r ${finalAttrs.contents}/usr/share/. $out/share/
    ln -s freshgram $out/bin/freshGram
    cat > $out/share/dbus-1/services/io.github.snowy-fluffy.freshgram.service <<EOF
    [D-BUS Service]
    Name=io.github.snowy-fluffy.freshgram
    Exec=$out/bin/freshGram
    EOF
  '';

  meta = {
    description = "freshGram Telegram Desktop fork";
    homepage = "https://github.com/Snowy-Fluffy/freshGram";
    platforms = [ "x86_64-linux" ];
    mainProgram = "freshgram";
  };
})
