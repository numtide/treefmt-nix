{
  description = "A very basic flake";

  inputs = {
    treefmt-nix.url = "path:..";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, treefmt-nix }@inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      checks = import ./. {
        nixpkgs = nixpkgs.legacyPackages.${system};
        treefmt-nix = treefmt-nix.lib;
      };
    });
}
