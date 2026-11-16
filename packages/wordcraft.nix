{
  lib, stdenvNoCC, fetchurl, dpkg, autoPatchelfHook, libgcc,
  dbus, libx11, libxcb, libxcursor, libxi, libxkbcommon, libxrandr,
  vulkan-loader, wayland,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wordcraft";
  version = "0.18.1";

  src = fetchurl {
    url = "https://github.com/storytold/wordcraft/releases/download/v${finalAttrs.version}/wordcraft-${finalAttrs.version}-linux-x86_64.deb";
    hash = "sha256-m1VxYd7XtZcxEsjCH2AP4LARDBpNMVEYRIVzPJb4fhk=";
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
    description = "Word processor with DOCX, ODT and RTF support";
    homepage = "https://github.com/storytold/wordcraft";
    changelog = "https://github.com/storytold/wordcraft/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; AND [ (OR [ mit asl20 ]) ofl cc0 publicDomain ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "wordcraft";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
