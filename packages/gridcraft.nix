{ fetchFromGitHub, gridcraft }:

gridcraft.overrideAttrs (finalAttrs: previousAttrs: {
  version = "0.19.1";
  src = fetchFromGitHub {
    owner = "storytold";
    repo = "gridcraft";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/dkhjj+BcL/+b/psYpRdO/vEG0zpiAt5fpIqkG7WLMw=";
  };
  cargoHash = "sha256-vkNDu60fJy9GOqQSqZItees+XOmta1qB5x5ibm8nBuM=";
  meta = previousAttrs.meta // {
    changelog = "https://github.com/storytold/gridcraft/releases/tag/v${finalAttrs.version}";
  };
  # Upstream tests require FHS paths and host Landlock outside the build sandbox.
  checkFlags = (previousAttrs.checkFlags or [ ]) ++ [ "--skip=sandbox::" ];
})
