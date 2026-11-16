{
  lib, stdenvNoCC, fetchurl, dpkg, autoPatchelfHook, libgcc,
  dbus, libx11, libxcb, libxcursor, libxi, libxkbcommon, libxrandr,
  vulkan-loader, wayland,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gridcraft";
  version = "0.19.1";

  src = fetchurl {
    url = "https://github.com/storytold/gridcraft/releases/download/v${finalAttrs.version}/gridcraft-${finalAttrs.version}-linux-x86_64.deb";
    hash = "sha256-PpsJPuO+2LHwCOpWyNYOapaJDiQxe+K7uT5DHzydgRI=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ dpkg autoPatchelfHook ];
  buildInputs = [ libgcc ];
  # Match the Nixpkgs package's libraries loaded by winit, wgpu and rfd.
  runtimeDependencies = [
    dbus libx11 libxcb libxcursor libxi libxkbcommon libxrandr vulkan-loader wayland
  ];

  installPhase = ''
    runHook preInstall
    dpkg-deb -x "$src" unpacked
    mkdir -p "$out"
    cp -r unpacked/usr/. "$out/"
    runHook postInstall
  '';

  meta = {
    description = "Spreadsheet app with XLSX, CSV and TSV support";
    homepage = "https://github.com/storytold/gridcraft";
    changelog = "https://github.com/storytold/gridcraft/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; OR [ mit asl20 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gridcraft";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
