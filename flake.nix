{
  description = "Personal desktop application packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = import ./packages.nix { inherit system nixpkgs; };
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.nix-update ];
      };
    };
}
