{
  description = "treefmt nix configuration modules";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      treefmtEval = forAllSystems (system:
        self.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      lib = import ./.;

      flakeModule = ./flake-module.nix;

      formatter = forAllSystems (system:
        treefmtEval.${system}.config.build.wrapper
      );

      checks = forAllSystems
        (system:
          (import ./tests {
            pkgs = nixpkgs.legacyPackages.${system};
            treefmt-nix = self.lib;
          }) // {
            formatting = treefmtEval.${system}.config.build.check self;
          }
        );
    };
}
