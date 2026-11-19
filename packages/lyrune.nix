{
  lib, stdenvNoCC, fetchurl, dpkg, autoPatchelfHook, libgcc,
  alsa-lib, libxcb, libxkbcommon,
  dbus, fontconfig, glib, libglvnd, libx11, libxcursor, libxi, libxrandr,
  vulkan-loader, wayland,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lyrune";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/amtoaer/lyrune/releases/download/v${finalAttrs.version}/lyrune-v${finalAttrs.version}-linux-amd64.deb";
    hash = "sha256-RfNMo7tMearTd1wfXlVhwVAq/bxsTsf2OSYD2YDLmdc=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ libgcc alsa-lib libxcb libxkbcommon ];
  # Graphics and desktop libraries may be opened dynamically.
  runtimeDependencies = [
    dbus fontconfig glib libglvnd libx11 libxcursor libxi libxrandr
    vulkan-loader wayland
  ];

  installPhase = ''
    runHook preInstall
    dpkg-deb -x "$src" unpacked
    mkdir -p "$out"
    cp -r unpacked/usr/. "$out/"
    runHook postInstall
  '';

  meta = {
    description = "Linux QQ Music desktop client";
    homepage = "https://github.com/amtoaer/lyrune";
    platforms = [ "x86_64-linux" ];
    mainProgram = "lyrune";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
