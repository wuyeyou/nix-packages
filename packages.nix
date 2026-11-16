{
  system ? builtins.currentSystem,
  overlays ? [ ],
  nixpkgs ? (builtins.getFlake (toString ./.)).inputs.nixpkgs,
}:
let
  pkgs = import nixpkgs { inherit system overlays; };
in {
  cherry-studio = pkgs.callPackage ./packages/cherry-studio.nix { };
  wordcraft = pkgs.callPackage ./packages/wordcraft.nix { };
  gridcraft = pkgs.callPackage ./packages/gridcraft.nix { };
  lyrune = pkgs.callPackage ./packages/lyrune.nix { };
  freshgram = pkgs.callPackage ./packages/freshgram.nix { };
}
