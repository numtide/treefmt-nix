{
  description = "treefmt nix configuration modules";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      lib = import ./.;

      flakeModule = ./flake-module.nix;

      formatter = forAllSystems (system:
        import ./treefmt.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          treefmt-nix = self.lib;
        }
      );

      checks = forAllSystems (system:
        import ./tests {
          pkgs = nixpkgs.legacyPackages.${system};
          treefmt-nix = self.lib;
        }
      );
    };
}
