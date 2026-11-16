{ fetchFromGitHub, wordcraft }:

wordcraft.overrideAttrs (finalAttrs: previousAttrs: {
  version = "0.18.1";
  src = fetchFromGitHub {
    owner = "storytold";
    repo = "wordcraft";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n8BQIiX6C3D8pd8pil/reM/ffSW+cPEsI/OuQSUrYus=";
  };
  cargoHash = "sha256-gsiSbjdpjKKtWfYr2xcyLiGWamy7qGGSKOraRvnaVAM=";
  meta = previousAttrs.meta // {
    changelog = "https://github.com/storytold/wordcraft/releases/tag/v${finalAttrs.version}";
  };
})
